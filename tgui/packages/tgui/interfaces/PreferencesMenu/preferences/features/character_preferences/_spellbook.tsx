import { Feature, FeatureValueProps } from '../base';
import { Button, Stack } from '../../../../../components';

export const spellbook: Feature<undefined, undefined> = {
  name: 'Open spellbook',
  component: (props: FeatureValueProps<undefined, undefined>) => {
    const { act } = props;

    return (
      <Stack>
        <Stack.Item>
          <Button content="Open" onClick={() => act('open_spellbook')} />
        </Stack.Item>
      </Stack>
    );
  },
};
