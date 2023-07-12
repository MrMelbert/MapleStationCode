import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dimmer, Input, NoticeBox, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { CharacterPreview } from './common/CharacterPreview';

type typePath = string;

type LoadoutButton = {
  icon: string;
  act_key: string;
};

type LoadoutItem = {
  name: string;
  path: typePath;
  buttons: LoadoutButton[];
  tooltip_text?: string[];
};

type LoadoutCategory = {
  name: string;
  title: string;
  contents: LoadoutItem[];
};

type Data = {
  selected_loadout: typePath[];
  mob_name: string;
  job_clothes: BooleanLike;
  character_preview_view: string;
  loadout_tabs: LoadoutCategory[];
  tutorial_text: string;
};

export const _LoadoutManager = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { loadout_tabs } = data;
  const [tutorialStatus, setTutorialStatus] = useLocalState(
    context,
    'tutorialStatus',
    false
  );
  const [searchLoadout, setSearchLoadout] = useLocalState(
    context,
    'searchLoadout',
    ''
  );
  const [selectedTabName, setSelectedTab] = useLocalState(
    context,
    'tabs',
    loadout_tabs[0]?.name
  );

  return (
    <Window title="Loadout Manager" width={900} height={645}>
      <Window.Content height="100%">
        <Stack vertical>
          <Stack.Item>
            {!!tutorialStatus && <LoadoutTutorialDimmer />}
            <Section
              title="Loadout Categories"
              align="center"
              buttons={
                <>
                  <Button
                    icon="info"
                    align="center"
                    content="Tutorial"
                    onClick={() => setTutorialStatus(true)}
                  />
                  <Input
                    width="200px"
                    onInput={(event) => setSearchLoadout(event.target.value)}
                    placeholder="Search for item"
                    value={searchLoadout}
                  />
                </>
              }>
              <Tabs fluid align="center">
                {loadout_tabs.map((curTab) => (
                  <Tabs.Tab
                    key={curTab.name}
                    selected={
                      searchLoadout.length <= 1 &&
                      curTab.name === selectedTabName
                    }
                    onClick={() => {
                      setSelectedTab(curTab.name);
                      setSearchLoadout('');
                    }}>
                    {curTab.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item height="500px">
            <LoadoutTabs />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LoadoutTutorialDimmer = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { tutorial_text } = data;
  const [tutorialStatus, setTutorialStatus] = useLocalState(
    context,
    'tutorialStatus',
    false
  );
  return (
    <Dimmer>
      <Stack vertical align="center">
        <Stack.Item textAlign="center" preserveWhitespace>
          {tutorial_text}
        </Stack.Item>
        <Stack.Item>
          <Button
            mt={1}
            align="center"
            onClick={() => setTutorialStatus(false)}>
            Okay.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const ItemDisplay = (
  props: { item: LoadoutItem; active: boolean },
  context
) => {
  const { act } = useBackend<LoadoutItem>(context);
  const { item, active } = props;
  return (
    <Stack>
      <Stack.Item grow align="left">
        {item.name}
      </Stack.Item>
      {item.buttons.map((button) => (
        <Stack.Item key={button.act_key}>
          <Button
            icon={button.icon}
            onClick={() =>
              act(button.act_key, {
                path: item.path,
              })
            }
          />
        </Stack.Item>
      ))}
      <Stack.Item>
        <Button.Checkbox
          checked={active}
          content="Select"
          fluid
          tooltip={item.tooltip_text?.join('\n')}
          onClick={() =>
            act('select_item', {
              path: item.path,
              deselect: active,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const LoadoutTabDisplay = (
  props: { category: LoadoutCategory | undefined },
  context
) => {
  const { data } = useBackend<Data>(context);
  const { selected_loadout } = data;
  const { category } = props;
  if (!category) {
    return (
      <Stack.Item>
        <NoticeBox>
          Erroneous category detected! This is a bug, please report it.
        </NoticeBox>
      </Stack.Item>
    );
  }

  return (
    <>
      {category.contents.map((item) => (
        <Stack.Item key={item.name}>
          <ItemDisplay
            item={item}
            active={selected_loadout.includes(item.path)}
          />
        </Stack.Item>
      ))}
    </>
  );
};

const SearchDisplay = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { loadout_tabs, selected_loadout } = data;
  const [searchLoadout] = useLocalState(context, 'searchLoadout', '');

  const allLoadoutItems = () => {
    const concatItems: LoadoutItem[] = [];
    for (const tab of loadout_tabs) {
      for (const item of tab.contents) {
        concatItems.push(item);
      }
    }
    return concatItems.sort((a, b) => a.name.localeCompare(b.name));
  };
  const validLoadoutItems = allLoadoutItems().filter((item) =>
    item.name.toLowerCase().includes(searchLoadout.toLowerCase())
  );

  if (validLoadoutItems.length === 0) {
    return (
      <Stack.Item>
        <NoticeBox>No items found!</NoticeBox>
      </Stack.Item>
    );
  }

  return (
    <>
      {validLoadoutItems.map((item) => (
        <Stack.Item key={item.name}>
          <ItemDisplay
            item={item}
            active={selected_loadout.includes(item.path)}
          />
        </Stack.Item>
      ))}
    </>
  );
};

const LoadoutTabs = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { loadout_tabs } = data;
  const [selectedTabName] = useLocalState(
    context,
    'tabs',
    loadout_tabs[0]?.name
  );
  const [searchLoadout] = useLocalState(context, 'searchLoadout', '');
  const activeCategory = loadout_tabs.find((curTab) => {
    return curTab.name === selectedTabName;
  });

  const searching = searchLoadout.length > 1;

  return (
    <Stack fill>
      <Stack.Item grow>
        {searching || (activeCategory && activeCategory.contents) ? (
          <Section
            title={
              searching ? 'Searching...' : activeCategory?.title || 'Error'
            }
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
              {searching ? (
                <SearchDisplay />
              ) : (
                <LoadoutTabDisplay category={activeCategory} />
              )}
            </Stack>
          </Section>
        ) : (
          <Section fill>
            <Box>No contents for selected tab.</Box>
          </Section>
        )}
      </Stack.Item>
      <Stack.Item grow align="center">
        <LoadoutPreviewSection />
      </Stack.Item>
    </Stack>
  );
};

const LoadoutPreviewSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { mob_name, job_clothes, character_preview_view } = data;
  const [tutorialStatus] = useLocalState(context, 'tutorialStatus', false);
  return (
    <Section
      title={`Preview: ${mob_name}`}
      grow
      buttons={
        <Button.Checkbox
          align="center"
          content="Toggle Job Clothes"
          checked={job_clothes}
          onClick={() => act('toggle_job_clothes')}
        />
      }>
      <Stack height="450px" vertical>
        <Stack.Item grow align="center">
          {!tutorialStatus && (
            <CharacterPreview height="100%" id={character_preview_view} />
          )}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item align="center">
          <Stack>
            <Stack.Item>
              <Button
                icon="chevron-left"
                onClick={() =>
                  act('rotate_dummy', {
                    dir: 'left',
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="check-double"
                color="good"
                tooltip="Confirm loadout and exit UI."
                tooltipPosition="bottom"
                onClick={() => act('close_ui', { revert: 0 })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="chevron-right"
                onClick={() =>
                  act('rotate_dummy', {
                    dir: 'right',
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
