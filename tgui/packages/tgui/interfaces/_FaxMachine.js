import { useBackend, useSharedState, useLocalState } from '../backend';
import { BlockQuote, Box, Button, Divider, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const _FaxMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    display_name,
    emagged,
    can_send_cc_messages,
    can_recieve,
    recieved_paperwork = [],
    recieved_paper,
    stored_paper,
  } = data;

  const [tab, setTab] = useSharedState(context, 'tab', 1);

  const [
    selectedPaperTab,
    setSelectedPaper,
  ] = useLocalState(context, 'ref', recieved_paperwork[0]?.ref);

  const selectedPaper = recieved_paperwork.find(paper => {
    return paper.ref === selectedPaperTab;
  });

  return (
    <Window
      title="Fax Machine"
      width={550}
      height={630}
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
          title="Faxed Papers"
          buttons={(
            <Button
              color={emagged ? "bad" : "good"}
              content={emagged ? "Send to Syndicate Command"
                : "Send to Central Command"}
              disabled={tab !== 1
                || !stored_paper
                || !(can_send_cc_messages || emagged)}
              tooltip={"Send the contents of the paper currently inserted \
                in the machine to your employer. Response not guaranteed. \
                A copy of the sent paper will print, too - for record-keeping."}
              onClick={() => act('send_stored_paper')} />
          )}>
          <Stack vertical height={15}>
            <Stack.Item height={2}>
              <Tabs fluid>
                <Tabs.Tab
                  icon="copy"
                  selected={tab === 1}
                  onClick={() => setTab(1)}>
                  <b>Send A Fax</b>
                </Tabs.Tab>
                <Tabs.Tab
                  icon="broadcast-tower"
                  selected={tab === 2}
                  onClick={() => setTab(2)}>
                  <b>Recieved Faxes</b>
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item height={13}>
              {tab === 1 && (
                stored_paper ? (
                  <Box>
                    <span style={{ color: "lightblue", fontWeight: "bold" }}>Message:</span>
                    <BlockQuote>{stored_paper.contents}</BlockQuote>
                  </Box>
                ) : (
                  <Box>
                    <i>
                      Insert a paper into the machine fax its contents to
                      { emagged ? " the Syndicate" : " Central Command"}.
                    </i>
                  </Box>
                ))}
              {tab === 2 && (
                recieved_paper ? (
                  <Box>
                    <span style={{ color: "lightblue", fontWeight: "bold" }}>Message:</span>
                    <BlockQuote>{recieved_paper.contents}</BlockQuote>
                  </Box>
                ) : (
                  <Box>
                    <i>
                      No papers have been recieved from
                      { emagged ? " the Syndicate" : " Central Command"}, yet.
                    </i>
                  </Box>
                ))}
            </Stack.Item>
            <Stack.Item>
              {tab === 2 && recieved_paper && (
                <Button
                  disabled={!recieved_paper}
                  content="Print Recieved Fax"
                  tooltip={"Print the last recieved fax from "
                    + (emagged ? " the Syndicate." : " Central Command.")}
                  onClick={() => act('print_recieved_paper')} />
              )}
            </Stack.Item>
          </Stack>
        </Section>
        <Section
          title="Paperwork"
          buttons={(
            <Button.Checkbox
              checked={can_recieve}
              content="Toggle Incoming Paperwork"
              tooltip={(can_recieve ? "Disable" : "Enable")
                + " the ability for this fax machine \
                to recieve paperwork every five minutes."}
              onClick={() => act('toggle_recieving')}
            />
          )}>
          <Stack vertical grow>
            <Stack.Item height={2}>
              {recieved_paperwork && recieved_paperwork.length > 0 ? (
                <Tabs fluid>
                  {recieved_paperwork.map(paper => (
                    <Tabs.Tab
                      key={paper}
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
                <BlockQuote fontSize="14px">
                  {selectedPaper.contents}
                </BlockQuote>
              ) : (
                recieved_paperwork && recieved_paperwork.length > 0
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
                    <BlockQuote>
                      {selectedPaper.required_answer}
                    </BlockQuote>
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
                    tooltip="Print the selected paperwork. \
                      This is how you stamp and process the paperwork."
                    onClick={() => act('print_select_paperwork', {
                      ref: selectedPaper.ref,
                    })} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!selectedPaper || emagged}
                    content="Send Paper For Processing"
                    tooltip="Send the selected paperwork \
                      to your employer to check its \
                      validity and recieve your payment."
                    onClick={() => act('check_paper', {
                      ref: selectedPaper.ref,
                    })} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="bad"
                    disabled={!selectedPaper}
                    content="Delete Paper"
                    tooltip="Delete the selected paperwork from the machine."
                    onClick={() => act('delete_select_paperwork', {
                      ref: selectedPaper.ref,
                    })} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={(!recieved_paperwork
                      || recieved_paperwork.length <= 0) ? "good" : "caution"}
                    disabled={!recieved_paperwork
                      || recieved_paperwork.length <= 0}
                    content="Print All Papers"
                    tooltip="Print out all the paperwork stored in the machine."
                    onClick={() => act('print_all_paperwork')} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
