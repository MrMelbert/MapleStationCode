import { useBackend } from '../backend';
import { Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export const WarfareEvent = (props, context) => {
  const { act, data } = useBackend(context);
  const { selectedShells, fireDirection } = data;
  return (
    <Window title="Warfare Module" resizable theme="malfunction">
      <Window.Content scrollable>
        <Section title="Volley Configuration">
          <Flex
            direction="row"
            wrap="nowrap"
            align="center"
            justify="space-evenly"
          >
            <Flex.Item grow={1}>
              <Button.Confirm
                fluid
                icon="bomb"
                color="good"
                children="Fire Volley"
                confirmContent="Confirm Shell Volley?"
                onClick={() => act('fireShells')}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="arrows-rotate"
                color="light-grey"
                children="Change Firing Direction"
                onClick={() => act('changeDirection')}
              />
            </Flex.Item>
          </Flex>
          <Section title="Loaded Shells" />
        </Section>
      </Window.Content>
    </Window>
  );
};
