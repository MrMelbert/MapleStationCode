import { useBackend } from '../backend';
import { Button, Dropdown, Flex, Section } from '../components';
import { Window } from '../layouts';

export const WarfareEvent = (props, context) => {
  const { act, data } = useBackend(context);
  const { selectedShells } = data;

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
                confirmContent="Confirm Shell Volley?"
                onClick={() => act('fireShells')}
                textAlign="center"
              >
                {'Fire Volley'}
              </Button.Confirm>
            </Flex.Item>
            <Flex.Item grow={1}>
              <Dropdown
                fluid
                icon="arrows-rotate"
                color="blue"
                selected="Change Firing Direction"
                noChevron
                nowrap
                options={['North', 'South', 'East', 'West']}
                onSelected={(value) =>
                  act('changeDirection', { direction: value })
                }
              />
            </Flex.Item>
          </Flex>
          <Section title="Shell Menu">
            <Flex
              direction="row"
              wrap="nowrap"
              align="center"
              justify="space-evenly"
            >
              <Flex.Item grow={1} />
              <Flex.Item grow={1} />
            </Flex>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
