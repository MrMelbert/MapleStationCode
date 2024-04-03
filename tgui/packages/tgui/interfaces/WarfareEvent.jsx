import { useBackend } from '../backend';
import { Button, Dropdown, Flex, Section, Stack } from '../components';
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
            <Stack vertical fill>
              <Stack.Item>
                <Button
                  color="good"
                  icon="plus"
                  onClick={() =>
                    act('addShell', {
                      amount: reagentQuantity,
                    })
                  }
                >
                  {'Add Reagent'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Stack vertical>
                  {reagents.map((reagent) => (
                    <Stack.Item key={reagent.name}>
                      <Stack fill>
                        <Stack.Item mt={0.25} textColor="label">
                          {reagent.name + ':'}
                        </Stack.Item>
                        <Stack.Item mt={0.25} grow>
                          {reagent.volume}
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="minus"
                            color="bad"
                            onClick={() =>
                              act('remove', {
                                chem: reagent.name,
                              })
                            }
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
