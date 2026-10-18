import { Button, Stack } from 'tgui-core/components';

import { useBackend } from '../../../../../backend';
import type { Feature, FeatureValueProps } from '../base';

export const spellbook: Feature<undefined, undefined> = {
  name: 'Open spellbook',
  component: (props: FeatureValueProps<undefined, undefined>) => {
    const { act } = useBackend();

    return (
      <Stack>
        <Stack.Item>
          <Button content="Open" onClick={() => act('open_spellbook')} />
        </Stack.Item>
      </Stack>
    );
  },
};
