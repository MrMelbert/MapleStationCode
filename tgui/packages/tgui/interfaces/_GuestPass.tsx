import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

type Access = string;

type History = {
  granter: string | null;
  granter_job: string | null;
  granted: Access[] | null;
  duration: number | null;
  station_time: string | null;
  shift_time: string | null;
};

type Data = {
  selected_access: Access[];
  all_accesses: Record<string, Access[]>;
  access_readable: Record<Access, string>;
  set_time: number;
  min_time: number;
  max_time: number;
  max_given_accesses: number;
  access_history: History[] | null;
  swiped_id_name: string | null;
  swiped_id_job: string | null;
  swiped_id_access: Access[] | null;
};

const GuestPassMainPage = () => {
  const { act, data } = useBackend<Data>();

  const {
    all_accesses,
    access_readable,
    set_time,
    min_time,
    max_time,
    max_given_accesses,
    selected_access,
    swiped_id_access,
    swiped_id_job,
    swiped_id_name,
  } = data;

  return (
    <Stack fontSize="14px" vertical>
      <Stack.Item>
        <Button.Confirm
          disabled={!swiped_id_name || !selected_access.length}
          color="good"
          width="100%"
          textAlign="center"
          onClick={() => act('print_pass')}
        >
          Print Pass
        </Button.Confirm>
      </Stack.Item>
      <Stack.Item>
        <LabeledList>
          <LabeledList.Item label="Authenticator" verticalAlign="middle">
            <Button
              width="175px"
              onClick={() => act(swiped_id_name ? 'clear_id' : 'swipe_id')}
            >
              <Box
                align="right"
                style={{
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                  fontStyle: swiped_id_name ? '' : 'italic',
                }}
              >
                {swiped_id_name || 'Swipe ID'}
              </Box>
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Duration" verticalAlign="middle">
            <NumberInput
              width="175px"
              value={set_time}
              unit="Minutes"
              step={0.5}
              minValue={min_time}
              maxValue={max_time}
              onChange={(e, value) => act('change_time', { new_time: value })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Access" />
        </LabeledList>
      </Stack.Item>
      <Stack.Item>
        {Object.entries(all_accesses).map(([category, accesses]) => (
          <Stack key={category} vertical>
            <Stack.Item>
              <Collapsible
                fontSize="12px"
                title={category}
                open={Object.entries(all_accesses).length <= 3}
              >
                <Flex wrap fontSize="12px">
                  {accesses.map((access) => (
                    <Flex.Item key={access} mr={1} mb={1}>
                      <Button.Checkbox
                        fluid
                        checked={selected_access.includes(access)}
                        color={
                          selected_access?.includes(access) ? 'godo' : 'default'
                        }
                        disabled={
                          !swiped_id_access?.includes(access) ||
                          selected_access.length > max_given_accesses
                        }
                        tooltip={
                          swiped_id_access?.includes(access)
                            ? selected_access.length <= max_given_accesses
                              ? ''
                              : 'Max accesses reached'
                            : swiped_id_name
                              ? 'Inadequate Access'
                              : 'Please swipe ID'
                        }
                        onClick={() =>
                          act('toggle_access', { changed_access: access })
                        }
                      >
                        {access_readable[access]}
                      </Button.Checkbox>
                    </Flex.Item>
                  ))}
                </Flex>
              </Collapsible>
            </Stack.Item>
          </Stack>
        ))}
      </Stack.Item>
    </Stack>
  );
};

const GuestPassHistoryPage = () => {
  const { act, data } = useBackend<Data>();

  const { access_history, access_readable } = data;

  const grantedList = (granted: Access[]) => {
    return granted.map((access) => access_readable[access]).join(', ');
  };

  return (
    <Stack vertical>
      {(access_history || []).map((history, index) => (
        <Collapsible
          key={index}
          title={
            <Box
              ml={2.5}
              mt={-3.25}
              width="90%"
              style={{
                position: 'absolute',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
            >
              {(history.granter || 'Unknown') +
                ' - ' +
                (history.shift_time || 'Unknown')}
            </Box>
          }
        >
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Auth. Name" verticalAlign="middle">
                {history.granter || 'Unknown'}
              </LabeledList.Item>
              <LabeledList.Item label="Auth. Job" verticalAlign="middle">
                {history.granter_job || 'Unknown'}
              </LabeledList.Item>
              <LabeledList.Item label="Access" verticalAlign="middle">
                <Box style={{ textTransform: 'capitalize' }}>
                  {history.granted ? grantedList(history.granted) : 'Unknown'}{' '}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Duration" verticalAlign="middle">
                {history.duration || 'Unknown'} Minutes
              </LabeledList.Item>
              <LabeledList.Item label="Station Time" verticalAlign="middle">
                {history.station_time || 'Unknown'}
              </LabeledList.Item>
              <LabeledList.Item label="Shift Time" verticalAlign="middle">
                {history.shift_time || 'Unknown'}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Divider />
        </Collapsible>
      ))}
    </Stack>
  );
};

export const _GuestPass = () => {
  const [tab, setTab] = useState('main');

  return (
    <Window width={330} height={440} title="Guest Pass Kiosk">
      <Window.Content scrollable>
        <Section grow>
          <Tabs fluid>
            <Tabs.Tab
              icon="list"
              lineHeight="23px"
              selected={tab === 'main'}
              onClick={() => setTab('main')}
            >
              Create Pass
            </Tabs.Tab>
            <Tabs.Tab
              icon="book"
              lineHeight="23px"
              selected={tab === 'history'}
              onClick={() => setTab('history')}
            >
              View History
            </Tabs.Tab>
          </Tabs>
          <Divider />
          {tab === 'main' ? <GuestPassMainPage /> : <GuestPassHistoryPage />}
        </Section>
      </Window.Content>
    </Window>
  );
};
