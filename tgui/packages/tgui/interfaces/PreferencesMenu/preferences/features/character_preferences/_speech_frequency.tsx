import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import {
  FeatureNumberInput,
  type FeatureNumeric,
  type FeatureNumericData,
  type FeatureValueProps,
} from '../base';

const FeatureSpeechSound = (
  props: FeatureValueProps<number, number, FeatureNumericData>,
) => {
  const { act } = useBackend();

  return (
    <Stack>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_test_speech_sound');
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
  description:
    'Adjusts the frequency that your speech sounds play at. \
    A lower number results in deeper, slower speech, while \
    higher numbers result in higher, faster speech.',
  component: FeatureSpeechSound,
};

export const speech_sound_pitch_modifier: FeatureNumeric = {
  name: 'Speech Sound Pitch',
  description:
    'Adjusts the pitch that your speech sounds play at. \
    A lower number results in deeper speech, while \
    higher numbers result in higher speech.',
  component: FeatureSpeechSound,
};
