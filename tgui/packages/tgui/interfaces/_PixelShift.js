import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const _PixelShift = (props, context) => {
  const { act, data } = useBackend(context);
  const { x_shift, y_shift } = data;
  return (
    <Window title="Pixel Shift" width={160} height={170}>
      <Window.Content>
        <Section>
          <Stack vertical align="center">
            <Stack.Item>
              <Button
                align="center"
                icon="arrow-up"
                onClick={() => act('shift_posy')}
              />
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button icon="arrow-left" onClick={() => act('shift_negx')} />
                </Stack.Item>
                <Stack.Item>
                  <Button icon="times" onClick={() => act('reset_shift')} />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="arrow-right"
                    onClick={() => act('shift_posx')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Button icon="arrow-down" onClick={() => act('shift_negy')} />
            </Stack.Item>
            <Stack.Item>
              <Box>X offset: {x_shift}</Box>
              <Box>Y offset: {y_shift}</Box>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
