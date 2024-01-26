import { BooleanLike } from 'common/react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../components';
import { CharacterPreview } from './common/CharacterPreview';

type typePath = string;

type LoadoutButton = {
  icon: string;
  act_key?: string;
  tooltip?: string;
};

type LoadoutItem = {
  name: string;
  path: typePath;
  buttons: LoadoutButton[];
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
  loadout_preview_view: string;
  loadout_tabs: LoadoutCategory[];
  tutorial_text: string;
  current_slot: number;
  max_loadout_slots: number;
};

export const LoadoutPage = () => {
  const { data } = useBackend<Data>();
  const { loadout_tabs } = data;
  const [tutorialStatus, setTutorialStatus] = useLocalState(
    'tutorialStatus',
    false,
  );
  const [searchLoadout, setSearchLoadout] = useLocalState('searchLoadout', '');
  const [selectedTabName, setSelectedTab] = useLocalState(
    'tabs',
    loadout_tabs[0]?.name,
  );

  return (
    <Stack vertical fill>
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
                onInput={(event, value) => setSearchLoadout(value)}
                placeholder="Search for item"
                value={searchLoadout}
              />
            </>
          }
        >
          <Tabs fluid align="center">
            {loadout_tabs.map((curTab) => (
              <Tabs.Tab
                key={curTab.name}
                selected={
                  searchLoadout.length <= 1 && curTab.name === selectedTabName
                }
                onClick={() => {
                  setSelectedTab(curTab.name);
                  setSearchLoadout('');
                }}
              >
                {curTab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <LoadoutTabs />
      </Stack.Item>
    </Stack>
  );
};

const LoadoutTutorialDimmer = () => {
  const { data } = useBackend<Data>();
  const { tutorial_text } = data;
  const [tutorialStatus, setTutorialStatus] = useLocalState(
    'tutorialStatus',
    false,
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
            onClick={() => setTutorialStatus(false)}
          >
            Okay.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const ItemDisplay = (
  props: { item: LoadoutItem; active: boolean },
  context,
) => {
  const { act } = useBackend<LoadoutItem>();
  const { item, active } = props;
  return (
    <Stack>
      <Stack.Item grow align="left" style={{ textTransform: 'capitalize' }}>
        {item.name}
      </Stack.Item>
      {item.buttons.map((button) => (
        <Stack.Item key={button.act_key}>
          <Button
            icon={button.icon}
            tooltip={button.tooltip}
            disabled={button.act_key === undefined}
            onClick={() =>
              act('pass_to_loadout_item', {
                path: item.path,
                subaction: button.act_key,
              })
            }
          />
        </Stack.Item>
      ))}
      <Stack.Item>
        <Button.Checkbox
          checked={active}
          fluid
          onClick={() =>
            act('select_item', {
              path: item.path,
              deselect: active,
            })
          }
        >
          Select
        </Button.Checkbox>
      </Stack.Item>
    </Stack>
  );
};

const LoadoutTabDisplay = (props: {
  category: LoadoutCategory | undefined;
}) => {
  const { data } = useBackend<Data>();
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

const SearchDisplay = () => {
  const { data } = useBackend<Data>();
  const { loadout_tabs, selected_loadout } = data;
  const [searchLoadout] = useLocalState('searchLoadout', '');

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
    item.name.toLowerCase().includes(searchLoadout.toLowerCase()),
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
  const { act, data } = useBackend<Data>();
  const { loadout_tabs } = data;
  const [selectedTabName] = useLocalState('tabs', loadout_tabs[0]?.name);
  const [searchLoadout] = useLocalState('searchLoadout', '');
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
                tooltip="Clears ALL selected items from all categories."
                onClick={() => act('clear_all_items')}
              >
                Clear All Items
              </Button.Confirm>
            }
          >
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

const LoadoutPreviewSection = () => {
  const { act, data } = useBackend<Data>();
  const {
    mob_name,
    job_clothes,
    loadout_preview_view,
    current_slot,
    max_loadout_slots,
  } = data;

  const [tutorialStatus] = useLocalState('tutorialStatus', false);

  const loadoutSlots = (maxSlots: number) => {
    const slots: number[] = [];
    for (let i = 1; i < maxSlots + 1; i++) {
      slots.push(i);
    }
    return slots;
  };

  return (
    <Section
      title={`Preview: ${mob_name}`}
      grow
      height="100%"
      buttons={
        <Button.Checkbox
          align="center"
          content="Toggle Job Clothes"
          checked={job_clothes}
          onClick={() => act('toggle_job_clothes')}
        />
      }
    >
      {/* The heights on these sections are fucked, whatever fix it later */}
      <Stack vertical height="515px">
        <Stack.Item grow align="center">
          {!tutorialStatus && (
            <CharacterPreview height="100%" id={loadout_preview_view} />
          )}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item align="center">
          <Stack>
            {loadoutSlots(max_loadout_slots).map((slot) => (
              <Stack.Item key={slot}>
                <Button
                  color={slot === current_slot ? 'green' : 'grey'}
                  content={slot}
                  onClick={() => act('select_slot', { new_slot: slot })}
                />
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
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
