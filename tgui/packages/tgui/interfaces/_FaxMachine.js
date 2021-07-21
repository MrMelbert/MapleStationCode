import { useBackend, useSharedState, useLocalState } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const _FaxMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    display_name,
    emagged,
    can_send_cc_messages,
    recieved_paper = [],
    stored_paper,
  } = data;

  const [
    selectedPaperTab,
    setSelectedPaper,
  ] = useLocalState(context, 'ref', recieved_paper[0]?.ref);

  const selectedPaper = recieved_paper.find(paper => {
    return paper.ref === selectedPaperTab;
  });


  return (
    <Window
      title="Fax Machine"
      width={550}
      theme={emagged ? "syndicate":"ntos"}>
      <Window.Content>
        <Section
          title="Nanotrasen Fax Device"
          height={6.5}
          buttons={(
            !!emagged && <Button
              color="bad"
              content="Restore Routing Information"
              onClick={() => act('un_emag_machine')} />
          )}>
          Hello, {display_name}! {emagged ? "ERR- ERRoR. ERROR."
            : "Welcome to the Nanotrasen Approved Faxing Device!"}
        </Section>
        <Section
          title="Fax Paper"
          buttons={(
            <Button
              color={emagged ? "bad" : "good"}
              content={emagged ? "Send to Syndicate Command"
                : "Send to Central Command"}
              disabled={!stored_paper || !(can_send_cc_messages || emagged)}
              tooltip={"Send the contents of the paper currently inserted \
                in the machine to your employer. Response not guaranteed. \
                A copy of the sent paper will print, too - for record-keeping."}
              onClick={() => act('send_stored_paper')} />
          )}>
          <Stack vertical height={15}>
            <Stack.Item height={13}>
              {stored_paper ? (
                <Box>
                  <b>Message:</b> {stored_paper.contents}
                </Box>
              ) : (
                <Box>
                  <i>
                    Insert a paper into the machine fax its contents to
                    { emagged ? " the Syndicate" : " Central Command"}.
                  </i>
                </Box>
              )}
            </Stack.Item>
          </Stack>
        </Section>
        <Section
          title="Recieved Papers"
          buttons={(
            <Button.Checkbox
              selected={can_recieve}
              content="Toggle Incoming Paperwork"
              tooltip={(can_recieve ? "Disable" : "Enable")
                + " the ability for this fax machine \
                to recieve paperwork every five minutes."}
              onClick={() => act('toggle_recieving')}
            />
          )}>
          <Stack vertical grow>
            <Stack.Item height={2}>
              {recieved_paper && recieved_paper.length > 0 ? (
                <Tabs fluid>
                  {recieved_paper.map(paper => (
                    <Tabs.Tab
                      key={paper}
                      fluid
                      textAlign="center"
                      selected={paper.ref === selectedPaperTab}
                      onClick={() => setSelectedPaper(paper.ref)}>
                      Paper {paper.num}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              ) : (
                "No stored paperwork to process."
              )}
            </Stack.Item>
            <Stack.Item height={8}>
              {selectedPaper ? (
                selectedPaper.contents
              ) : (
                recieved_paper && recieved_paper.length > 0
                && ("No paper selected.")
              )}
            </Stack.Item>
            <Divider />
            <Stack.Item height={3} mb={1}>
              {!!selectedPaper && (
                <Stack vertical align="center" >
                  <Stack.Item grow>
                    <b>
                      To fulfill this paperwork, stamp accurately
                      and answer the following:
                    </b>
                  </Stack.Item>
                  <Stack.Item>
                    {selectedPaper.required_answer}
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
            <Stack.Item align="center" height={2}>
              <Stack>
                <Stack.Item>
                  <Button
                    color="good"
                    disabled={!selectedPaper}
                    content="Print Paper"
                    tooltip="Print out the currently selected paper.
                      This is how you stamp and process the paperwork."
                    onClick={() => act('print_recieved_paper', {
                      ref: selectedPaper.ref,
                    })} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!selectedPaper || emagged}
                    content="Send Paper For Processing"
                    tooltip="Send your finalized paperwork to your employer
                      to check its validity and recieve your payment."
                    onClick={() => act('check_paper', {
                      ref: selectedPaper.ref,
                    })} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={(!recieved_paper || recieved_paper.length <= 0)
                      ? "good" : "caution"}
                    disabled={!recieved_paper || recieved_paper.length <= 0}
                    content="Print All Papers"
                    tooltip="Print out all the paperwork stored in the machine."
                    onClick={() => act('print_all_recieved_papers')} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
