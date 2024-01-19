import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dimmer, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const _spellbookManager = (props, context) => {
  const { act, data } = useBackend(context);

  const { spellbook_tabs, disclaimer_status, explanation_status } = data;

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
        {!!disclaimer_status && <SpellbookTermsOfServiceDimmer />}
        {!!explanation_status && <MagicExplanationDimmer />}
        <Stack vertical>
          <Stack.Item>
            <Section
              title="Spellbook Categories"
              align="center"
              buttons={
                <>
                  <Button
                    icon="info"
                    align="center"
                    content="Terms of service"
                    onClick={() => act('toggle_disclaimer')}
                  />
                  <Button
                    icon="info"
                    align="center"
                    content="Magic system explanation"
                    onClick={() => act('toggle_explanation')}
                  />
                </>
              }>
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

export const SpellbookTermsOfServiceDimmer = (props, context) => {
  const { act, data } = useBackend(context);
  const { disclaimer_text } = data;
  return (
    <Dimmer align="center" textAlign="center">
      <Stack
        position="relative"
        nowrap={false}
        wrap="wrap"
        vertical
        justify="space-evenly">
        <Stack.Item textAlign="center" vertical preserveWhitespace>
          {disclaimer_text}
        </Stack.Item>
        <Stack.Item>
          <Button
            mt={1}
            align="center"
            onClick={() => act('toggle_disclaimer')}>
            READ THIS AT LEAST ONCE.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

export const MagicExplanationDimmer = (props, context) => {
  const { act, data } = useBackend(context);
  const { explanation_text } = data;
  return (
    <Dimmer align="center" textAlign="center">
      <Stack
        position="relative"
        nowrap={false}
        wrap="wrap"
        vertical
        justify="space-evenly">
        <Stack.Item
          textAlign="center"
          vertical
          preserveWhitespace
          fontSize="90%">
          {explanation_text}
        </Stack.Item>
        <Stack.Item>
          <Button
            mt={1}
            align="center"
            onClick={() => act('toggle_explanation')}>
            Okay.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
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
                      <Stack.Item vertical preserveWhitespace align="left">
                        {item.description}
                      </Stack.Item>
                      <Stack.Item
                        align="left"
                        fontSize="90%"
                        italic
                        vertical
                        preserveWhitespace
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
                        <Button
                          align="right"
                          disabled={!!item.has_params === false}
                          content="Customize"
                          tooltip={
                            item.has_params
                              ? ''
                              : 'This entry is not customizable.'
                          }
                          onClick={() =>
                            act('customize_item', {
                              path: item.type,
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
