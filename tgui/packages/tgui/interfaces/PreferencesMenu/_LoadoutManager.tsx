import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../../components';
import { CharacterPreview } from '../common/CharacterPreview';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

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

export type LoadoutCategory = {
  name: string;
  title: string;
  contents: LoadoutItem[];
};

type Data = {
  selected_loadout: typePath[];
  mob_name: string;
  job_clothes: BooleanLike;
  loadout_preview_view: string;
  current_slot: number;
};

export const LoadoutPage = () => {
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        return serverData ? (
          <LoadoutPageInner
            tutorial_text={serverData.loadout.tutorial_text}
            loadout_tabs={serverData.loadout.loadout_tabs}
            max_loadout_slots={serverData.loadout.max_loadout_slots}
          />
        ) : (
          <NoticeBox>Loading...</NoticeBox>
        );
      }}
    />
  );
};

const LoadoutPageInner = (props: {
  tutorial_text: string;
  loadout_tabs: LoadoutCategory[];
  max_loadout_slots: number;
}) => {
  const { tutorial_text, loadout_tabs, max_loadout_slots } = props;
  const [tutorialStatus, setTutorialStatus] = useState<boolean>(false);
  const [searchLoadout, setSearchLoadout] = useState<string>('');
  const [selectedTabName, setSelectedTab] = useState<string>(
    loadout_tabs[0].name,
  );

  return (
    <Stack vertical fill>
      <Stack.Item>
        {!!tutorialStatus && (
          <LoadoutTutorialDimmer
            text={tutorial_text}
            updateTutorialState={setTutorialStatus}
          />
        )}
        <Section
          title="Loadout Categories"
          align="center"
          buttons={
            <>
              <Button
                icon="info"
                align="center"
                onClick={() => setTutorialStatus(true)}
              >
                {'Tutorial'}
              </Button>
              <Input
                width="200px"
                onInput={(_, value) => setSearchLoadout(value)}
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
        <LoadoutTabs
          slots={max_loadout_slots}
          loadout_tabs={loadout_tabs}
          currentTab={selectedTabName}
          currentSearch={searchLoadout}
          currentTutorialStatus={tutorialStatus}
        />
      </Stack.Item>
    </Stack>
  );
};
const LoadoutTutorialDimmer = (props: {
  text: string;
  updateTutorialState: (newState: boolean) => void;
}) => {
  return (
    <Dimmer>
      <Stack vertical align="center">
        <Stack.Item textAlign="center" preserveWhitespace>
          {props.text}
        </Stack.Item>
        <Stack.Item>
          <Button
            mt={1}
            align="center"
            onClick={() => props.updateTutorialState(false)}
          >
            Okay.
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const ItemDisplay = (props: { item: LoadoutItem; active: boolean }) => {
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

const SearchDisplay = (props: {
  loadout_tabs: LoadoutCategory[];
  currentSearch: string;
}) => {
  const { data } = useBackend<Data>();
  const { selected_loadout } = data;
  const { loadout_tabs, currentSearch } = props;

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
    item.name.toLowerCase().includes(currentSearch.toLowerCase()),
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

const LoadoutTabs = (props: {
  slots: number;
  loadout_tabs: LoadoutCategory[];
  currentTab: string;
  currentSearch: string;
  currentTutorialStatus: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const {
    slots,
    loadout_tabs,
    currentTab,
    currentSearch,
    currentTutorialStatus,
  } = props;
  const activeCategory = loadout_tabs.find((curTab) => {
    return curTab.name === currentTab;
  });
  const searching = currentSearch.length > 1;

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
                <SearchDisplay
                  loadout_tabs={loadout_tabs}
                  currentSearch={currentSearch}
                />
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
        <LoadoutPreviewSection
          slots={slots}
          tutorialStatus={currentTutorialStatus}
        />
      </Stack.Item>
    </Stack>
  );
};

const LoadoutPreviewSection = (props: {
  slots: number;
  tutorialStatus: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { mob_name, job_clothes, loadout_preview_view, current_slot } = data;
  const { slots, tutorialStatus } = props;

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
            {loadoutSlots(slots).map((slot) => (
              <Stack.Item key={slot}>
                <Button
                  color={slot === current_slot ? 'green' : 'grey'}
                  onClick={() => act('select_slot', { new_slot: slot })}
                >
                  {slot}
                </Button>
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
