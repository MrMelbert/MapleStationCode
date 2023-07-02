import { FeatureNumeric, FeatureNumericData, FeatureNumberInput, FeatureValueProps } from '../base';
import { Stack, Button } from '../../../../../components';

const FeatureSpeechSoundFrequency = (
  props: FeatureValueProps<number, number, FeatureNumericData>
) => {
  return (
    <Stack>
      <Stack.Item>
        <Button
          onClick={() => {
            props.act('play_test_speech_sound');
          }}
          icon="play"
        />
      </Stack.Item>
      <Stack.Item grow>
        <FeatureNumberInput {...props} />
      </Stack.Item>
    </Stack>
  );
};

export const speech_sound_frequency_modifier: FeatureNumeric = {
  name: 'Speech Sound Frequency',
  component: FeatureSpeechSoundFrequency,
};
