import { Box, Flex, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { NukeKeypad } from './NuclearBomb';

type Data = {
  input_code: string;
  locked: BooleanLike;
  lock_set: BooleanLike;
  lock_code: BooleanLike;
};

export const LockedSafe = (props) => {
  const { act, data } = useBackend<Data>();
  const { input_code, locked, lock_code } = data;
  return (
    <Window width={300} height={440} theme="retro">
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Box mb="6px" className="NuclearBomb__displayBox">
              {input_code}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box className="NuclearBomb__displayBox">
              {!lock_code && 'No password set.'}
              {!!lock_code && (!locked ? 'Unlocked' : 'Locked')}
            </Box>
          </Stack.Item>
          <Stack.Item grow align="center">
            <Flex width="100%">
              <Flex.Item>
                <NukeKeypad />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
