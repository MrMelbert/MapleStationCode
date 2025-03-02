import {
  BlockQuote,
  Box,
  Button,
  Dimmer,
  Divider,
  Dropdown,
  Icon,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState, useSharedState } from '../backend';
import { Window } from '../layouts';

enum historyType {
  Send = 'Send',
  Receive = 'Receive',
}

type Paperwork = Paper & {
  num: number;
  required_answer: string;
};

type Paper = {
  ref: string;
  contents: string;
  source: string;
};

type History = {
  history_type: historyType;
  history_fax_name: string;
  history_time: string;
  iterator: number;
};

type Data = {
  display_name: string;
  destination_options: string[];
  default_destination: string;
  received_paperwork: Paperwork[];
  received_paper: Paper | null;
  stored_paper: Paper | null;
  history: History[];
  can_send: BooleanLike;
  can_receive: BooleanLike;
  can_toggle_can_receive: BooleanLike;
  emagged: BooleanLike;
  unread_message: BooleanLike;
};

export const _FaxMachine = (props, context) => {
  const { act, data } = useBackend<Data>();
  const {
    display_name,

    destination_options = [],
    default_destination,
    received_paperwork = [],
    received_paper,
    stored_paper,
    history = [],

    can_send,
    can_receive,
    can_toggle_can_receive,
    emagged,
    unread_message,
  } = data;

  const [tab, setTab] = useSharedState('tab', 1);

  const [selectedPaperTab, setSelectedPaper] = useLocalState(
    'ref',
    received_paperwork[0]?.ref,
  );

  const [destination, setDestination] = useLocalState(
    'dest',
    default_destination,
  );

  const selectedPaper = received_paperwork.find((paper) => {
    return paper.ref === selectedPaperTab;
  });

  const selectedDestination = destination_options.find((dest) => {
    return dest === destination;
  });

  return (
    <Window width={550} height={630} theme={emagged ? 'syndicate' : 'ntos'}>
      <Window.Content>
        <Section
          title="Nanotrasen Fax Device"
          height={6}
          buttons={
            !!emagged && (
              <Button
                color="bad"
                content="Restore Routing Information"
                onClick={() => act('un_emag_machine')}
              />
            )
          }
        >
          Hello, {display_name}!{' '}
          {emagged
            ? 'ERR- ERRoR. ERROR.'
            : 'Welcome to the Nanotrasen Approved Faxing Device!'}
        </Section>
        <Section title="Faxed Papers">
          <Stack vertical height={15}>
            <Stack.Item height={2}>
              <Tabs>
                <Tabs.Tab
                  width="30%"
                  icon="copy"
                  selected={tab === 1}
                  onClick={() => setTab(1)}
                  bold
                >
                  Send A Fax
                </Tabs.Tab>
                <Tabs.Tab
                  width="40%"
                  icon="broadcast-tower"
                  selected={tab === 2}
                  onClick={() => {
                    setTab(2);
                    act('read_last_received');
                  }}
                >
                  <Stack>
                    <Stack.Item textAlign="left" bold>
                      Received Faxes
                    </Stack.Item>
                    {received_paper && !!unread_message && (
                      <Stack.Item grow textAlign="center" color="Yellow" italic>
                        New!
                      </Stack.Item>
                    )}
                  </Stack>
                </Tabs.Tab>
                <Tabs.Tab
                  width="30%"
                  icon="scroll"
                  selected={tab === 3}
                  onClick={() => setTab(3)}
                  bold
                >
                  History
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item mt={1} height={13}>
              {tab === 1 &&
                (stored_paper ? (
                  <Box mt={1} bold color={emagged ? 'lightgreen' : 'lightblue'}>
                    Message to Send:
                    <BlockQuote mt={1} color={''}>
                      {stored_paper.contents}
                    </BlockQuote>
                  </Box>
                ) : (
                  <Box italic>
                    Insert a paper into the machine to fax its contents
                    somewhere.
                  </Box>
                ))}
              {tab === 2 &&
                (received_paper ? (
                  <Box mt={1} bold color="gold">
                    Message from {received_paper.source}:
                    <BlockQuote mt={1} color={''}>
                      {received_paper.contents}
                    </BlockQuote>
                  </Box>
                ) : (
                  <Box italic>No papers have been received.</Box>
                ))}
              {tab === 3 && (
                <Section scrollable fill>
                  <LabeledList>
                    {history.map((history_item) => (
                      <LabeledList.Item
                        key={history_item.iterator}
                        label={`${history_item.iterator}`}
                      >
                        {history_item.history_type === historyType.Send ? (
                          <Box color="Green">
                            Sent to {history_item.history_fax_name} at{' '}
                            {history_item.history_time}
                          </Box>
                        ) : (
                          <Box color="Red">
                            Received from {history_item.history_fax_name} at{' '}
                            {history_item.history_time}
                          </Box>
                        )}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                </Section>
              )}
            </Stack.Item>
            <Stack.Item>
              {tab === 1 && stored_paper && (
                <Stack>
                  <Stack.Item>
                    <Button
                      height="100%"
                      icon="fax"
                      color={emagged ? 'bad' : 'good'}
                      content="Send to: "
                      disabled={tab !== 1 || !stored_paper || !can_send}
                      tooltip={
                        'Send the contents of the paper currently inserted \
                      in the machine to the destination specified. \
                      Response not guaranteed.'
                      }
                      onClick={() => {
                        act('send_stored_paper', {
                          destination_machine: destination,
                        });
                        data.stored_paper = null; // this is probably bad but I can't figure out a way to get it to update. Don't replicate
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Dropdown
                      width="100%"
                      selected={selectedDestination}
                      options={destination_options}
                      onSelected={(dest) => setDestination(dest)}
                    />
                  </Stack.Item>
                </Stack>
              )}
              {tab === 2 && received_paper && (
                <Stack>
                  <Stack.Item>
                    <Button
                      disabled={!received_paper}
                      content="Print received Fax"
                      tooltip="Print the last received fax."
                      onClick={() => {
                        act('print_received_paper');
                        data.received_paper = null; // this is probably bad but I can't figure out a way to get it to update. Don't replicate
                      }}
                    />
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
          </Stack>
        </Section>
        <Section
          title="Paperwork"
          buttons={
            <Button.Checkbox
              checked={can_receive}
              disabled={!can_toggle_can_receive}
              content="Toggle Incoming Paperwork"
              tooltip={
                can_toggle_can_receive
                  ? (can_receive ? 'Disable' : 'Enable') +
                    ' the ability for this fax machine \
                to receive paperwork every five minutes.'
                  : 'This fax machine cannot receive paperwork.'
              }
              onClick={() => act('toggle_recieving')}
            />
          }
        >
          {!can_receive && !can_toggle_can_receive && (
            <Dimmer>
              <Stack vertical align="center">
                <Stack.Item>
                  <Icon size={6} name="file-circle-xmark" />
                </Stack.Item>
                <Stack.Item fontSize="16px">
                  This fax machine cannot receive paperwork.
                </Stack.Item>
              </Stack>
            </Dimmer>
          )}
          <Stack vertical>
            <Stack.Item height={2}>
              {received_paperwork && received_paperwork.length > 0 ? (
                <Tabs>
                  {received_paperwork.map((paper) => (
                    <Tabs.Tab
                      width="12.5%"
                      key={paper.ref}
                      textAlign="center"
                      selected={paper.ref === selectedPaperTab}
                      onClick={() => setSelectedPaper(paper.ref)}
                    >
                      Paper {paper.num}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              ) : (
                <Box italic>No stored paperwork to process.</Box>
              )}
            </Stack.Item>
            <Stack.Item height={8}>
              {selectedPaper ? (
                <BlockQuote fontSize="14px">
                  {selectedPaper.contents}
                </BlockQuote>
              ) : (
                received_paperwork &&
                received_paperwork.length > 0 &&
                'No paper selected.'
              )}
            </Stack.Item>
            <Divider />
            <Stack.Item height={3} mb={1}>
              {!!selectedPaper && (
                <Stack vertical align="center">
                  <Stack.Item bold>
                    To fulfill this paperwork, stamp accurately and answer the
                    following:
                  </Stack.Item>
                  <Stack.Item>
                    <BlockQuote>{selectedPaper.required_answer}</BlockQuote>
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
                    onClick={() =>
                      act('print_select_paperwork', {
                        ref: selectedPaper?.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!selectedPaper || emagged}
                    content="Send Paper For Processing"
                    tooltip="Send the selected paperwork \
                      to your employer to check its \
                      validity and receive your payment."
                    onClick={() =>
                      act('check_paper', {
                        ref: selectedPaper?.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="bad"
                    disabled={!selectedPaper}
                    content="Delete Paper"
                    tooltip="Delete the selected paperwork from the machine."
                    onClick={() =>
                      act('delete_select_paperwork', {
                        ref: selectedPaper?.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={
                      !received_paperwork || received_paperwork.length <= 0
                        ? 'good'
                        : 'caution'
                    }
                    disabled={
                      !received_paperwork || received_paperwork.length <= 0
                    }
                    content="Print All Papers"
                    tooltip="Print out all the paperwork stored in the machine."
                    onClick={() => act('print_all_paperwork')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
