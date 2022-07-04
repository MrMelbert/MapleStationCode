import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dimmer, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { CharacterPreview } from "./PreferencesMenu/CharacterPreview";

export const _LoadoutManager = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    loadout_tabs,
    tutorial_status,
  } = data;

  const [selectedTabName, setSelectedTab] = useLocalState(
    context, 'tabs', loadout_tabs[0]?.name);
  const selectedTab = loadout_tabs.find(curTab => {
    return curTab.name === selectedTabName;
  });

  return (
    <Window
      title="Loadout Manager"
      width={900}
      height={650}>
      <Window.Content height="100%">
        { !!tutorial_status && (
          <LoadoutTutorialDimmer />
        )}
        <Stack vertical>
          <Stack.Item>
            <Section
              title="Loadout Categories"
              align="center"
              buttons={(
                <Button
                  icon="info"
                  align="center"
                  content="Tutorial"
                  onClick={() => act('toggle_tutorial')} />
              )}>
              <Tabs fluid align="center">
                {loadout_tabs.map(curTab => (
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
            <LoadoutTabs
              tab={selectedTab} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const LoadoutTutorialDimmer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    tutorial_text,
  } = data;
  return (
    <Dimmer>
      <Stack
        vertical
        align="center">
        <Stack.Item
          textAlign="center"
          preserveWhitespace>
          {tutorial_text}
        </Stack.Item>
        <Stack.Item>
          <Button
            mt={1}
            align="center"
            onClick={() => act('toggle_tutorial')}>
            Okay.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

export const LoadoutTabs = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    selected_loadout,
  } = data;

  return (
    <Stack fill>
      <Stack.Item grow >
        { props.tab && props.tab.contents ? (
          <Section
            title={props.tab.title}
            fill
            scrollable
            buttons={(
              <Button.Confirm
                icon="times"
                color="red"
                align="center"
                content="Clear All Items"
                tooltip="Clears ALL selected items from all categories."
                onClick={() => act('clear_all_items')} />
            )}>
            <Stack vertical>
              {props.tab.contents.map(item => (
                <Stack.Item key={item.name}>
                  <Stack>
                    <Stack.Item grow align="left">
                      {item.name}
                    </Stack.Item>
                    { !!item.is_greyscale
                    && (
                      <Stack.Item>
                        <Button
                          icon="palette"
                          onClick={() => act('select_color', {
                            path: item.path,
                          })} />
                      </Stack.Item>
                    )}
                    { !!item.is_renamable
                    && (
                      <Stack.Item>
                        <Button
                          icon="pen"
                          onClick={() => act('set_name', {
                            path: item.path,
                          })} />
                      </Stack.Item>
                    )}
                    { !!item.is_reskinnable
                    && (
                      <Stack.Item>
                        <Button
                          icon="theater-masks"
                          onClick={() => act('set_skin', {
                            path: item.path,
                          })} />
                      </Stack.Item>
                    )}
                    { !!item.is_layer_adjustable
                    && (
                      <Stack.Item>
                        <Button
                          icon="arrow-down"
                          onClick={() => act('set_layer', {
                            path: item.path,
                          })} />
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Button.Checkbox
                        checked={selected_loadout.includes(item.path)}
                        content="Select"
                        fluid
                        tooltip={item.tooltip_text
                          ? (item.tooltip_text) : ("")}
                        onClick={() => act('select_item', {
                          path: item.path,
                          deselect:
                            selected_loadout.includes(item.path),
                        })} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        ) : (
          <Section fill>
            <Box>
              No contents for selected tab.
            </Box>
          </Section>
        )}
      </Stack.Item>
      <Stack.Item grow align="center">
        <LoadoutPreviewSection />
      </Stack.Item>
    </Stack>
  );
};

export const LoadoutPreviewSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    mob_name,
    job_clothes,
    character_preview_view,
  } = data;
  return (
    <Section
      title={`Preview: ${mob_name}`}
      grow
      buttons={(
        <Button.Checkbox
          align="center"
          content="Toggle Job Clothes"
          checked={job_clothes}
          onClick={() => act('toggle_job_clothes')} />
      )}>
      <Stack height="450px" vertical>
        <Stack.Item grow align="center">
          <CharacterPreview
            height="100%"
            id={character_preview_view} />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item align="center">
          <Stack>
            <Stack.Item>
              <Button
                icon="check-double"
                color="good"
                tooltip="Confirm loadout and exit UI."
                onClick={() => act('close_ui', { revert: 0 })} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="chevron-left"
                tooltip="Turn model preview to the left."
                onClick={() => act('rotate_dummy', {
                  dir: "left",
                })} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="sync"
                disabled={1}
                tooltip="Toggle viewing all \
                preview directions at once."
                onClick={() => act('show_all_dirs')} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="chevron-right"
                tooltip="Turn model preview to the right."
                onClick={() => act('rotate_dummy', {
                  dir: "right",
                })} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="times"
                color="bad"
                tooltip="Revert loadout and exit UI."
                onClick={() => act('close_ui', { revert: 1 })} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
