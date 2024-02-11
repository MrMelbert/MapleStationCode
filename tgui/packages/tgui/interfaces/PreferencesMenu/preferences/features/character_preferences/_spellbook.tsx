import { Button, Stack } from '../../../../../components';
import { Feature, FeatureValueProps } from '../base';

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
