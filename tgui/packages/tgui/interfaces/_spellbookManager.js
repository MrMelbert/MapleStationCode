import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const _spellbookManager = (props, context) => {
  const { act, data } = useBackend(context);

  const { spellbook_tabs } = data;

  const [selectedTabName, setSelectedTab] = useLocalState(
    context,
    'tabs',
    spellbook_tabs[0]?.name
  );
  const selectedTab = spellbook_tabs.find((curTab) => {
    return curTab.name === selectedTabName;
  });

  return (
    <Window title="Spellbook" width={900} height={650} theme="wizard">
      <Window.Content height="100%">
        <Stack vertical>
          <Stack.Item>
            <Section title="Spellbook Categories" align="center">
              <Tabs fluid align="center">
                {spellbook_tabs.map((curTab) => (
                  <Tabs.Tab
                    key={curTab.name}
                    selected={curTab.name === selectedTabName}
                    onClick={() => setSelectedTab(curTab.name)}>
                    {curTab.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item height="500px">
            <SpellbookTabs tab={selectedTab} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const SpellbookTabs = (props, context) => {
  const { act, data } = useBackend(context);

  const { selected_items } = data;

  return (
    <Stack fill>
      <Stack.Item grow>
        {props.tab && props.tab.contents ? (
          <Section
            title={props.tab.title}
            fill
            scrollable
            buttons={
              <Button.Confirm
                icon="times"
                color="red"
                align="center"
                content="Clear All Items"
                tooltip="Clears ALL selected items from all categories."
                onClick={() => act('clear_all_items')}
              />
            }>
            <Stack vertical>
              {props.tab.contents.map((item) => (
                <Stack.Item key={item.name}>
                  <Section fill backgroundColor="rgba(0, 0, 0, 0.2)">
                    <Stack direction="column">
                      <Stack.Item vertical align="left" fontSize="150%" bold>
                        {item.name + ': ' + item.entry_type}
                      </Stack.Item>
                      <Stack.Item vertical align="left">
                        {item.description}
                      </Stack.Item>
                      <Stack.Item
                        align="left"
                        fontSize="90%"
                        italic
                        vertical
                        textColor="#7F92A2">
                        {item.lore}
                      </Stack.Item>
                      <Stack.Item>
                        <Button.Checkbox
                          align="right"
                          checked={selected_items.includes(item.type)}
                          disabled={!item.can_be_picked}
                          content="Select"
                          tooltip={item.tooltip_text ? item.tooltip_text : ''}
                          onClick={() =>
                            act('select_item', {
                              path: item.type,
                              deselect: selected_items.includes(item.type),
                            })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        ) : (
          <Section fill>
            <Box>No contents for selected tab.</Box>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};
