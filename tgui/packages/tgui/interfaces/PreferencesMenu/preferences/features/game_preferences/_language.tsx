import { Feature, FeatureValueProps } from '../base';
import { Button, Stack } from '../../../../../components';

export const language: Feature<undefined, undefined> = {
  name: 'Access Languages',
  component: (props: FeatureValueProps<undefined, undefined>) => {
    const { act } = props;

    return (
      <Stack>
        <Stack.Item>
          <Button content="Open" onClick={() => act('open_language_picker')} />
        </Stack.Item>
      </Stack>
    );
  },
};
