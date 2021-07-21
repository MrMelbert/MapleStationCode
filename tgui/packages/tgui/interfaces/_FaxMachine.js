import { useBackend, useSharedState } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const _FaxMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recieved_paper = [],
    stored_paper,
  } = data;

  return (
    <Window
      title="Fax Machine"
      width={400}
      height={575}
      theme="ntos">
      <Window.Content>
        <Section title="Nanotrasen Approved Fax Machine">
          Welcome to the Nanotrasen Approved Fax Machine!
        </Section>
        <Section title="Fax Paper" scrollable>
          <Stack vertical height={15}>
            <Stack.Item grow>
              {stored_paper ? (
                <Box>Stored Paper: {stored_paper.title}</Box>
              ) : (
                <Box>
                  Insert a paper into the machine to fax it to Central Command.
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                color="good"
                disabled={!stored_paper}
                content="Send Paper Contents"
              />
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Recieved Papers" scrollable>
          <Stack vertical height={15}>
            <Stack.Item grow>
              {recieved_paper && recieved_paper.len ? (
                <Box>Stored Paper: {stored_paper.title}</Box>
              ) : (
                <Box>
                  No recieved papers.
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                color="good"
                disabled={!stored_paper}
                content="Print Paper"
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
