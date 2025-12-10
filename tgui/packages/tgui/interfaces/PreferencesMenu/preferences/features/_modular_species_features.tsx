import { Button, Stack } from 'tgui-core/components';
import { useBackend } from '../../../../backend';
import type { PreferencesMenuData } from '../../types';
import { useServerPrefs } from '../../useServerPrefs';
import {
  CheckboxInput,
  type Feature,
  type FeatureChoiced,
  type FeatureChoicedServerData,
  FeatureColorInput,
  FeatureNumberInput,
  type FeatureNumeric,
  type FeatureToggle,
  type FeatureValueProps,
} from './base';
import { FeatureDropdownInput } from './dropdowns';

export const feature_head_tentacles: FeatureChoiced = {
  name: 'Head Tentacles',
  component: FeatureDropdownInput,
};

export const feature_synth_head_cover: FeatureChoiced = {
  name: 'Head Cover',
  component: FeatureDropdownInput,
};

export const hair_lizard: FeatureToggle = {
  name: 'Hair Lizard',
  description: 'Check to spawn as a Lizard with hair.',
  component: CheckboxInput,
};

export const hiss_length: FeatureNumeric = {
  name: 'Hiss Length',
  description: 'How long do you hissssss for?',
  component: FeatureNumberInput,
};

export const feature_lizard_horn_color: Feature<string> = {
  name: 'Horn Color',
  component: FeatureColorInput,
};

export const feature_lizard_horn_layer: FeatureChoiced = {
  name: 'Horn Layer',
  description: 'Determines what layer your horns are on.',
  component: FeatureDropdownInput,
};

export const feature_lizard_frill_layer: FeatureChoiced = {
  name: 'Frill Layer',
  description: 'Determines what layer your frills are on.',
  component: FeatureDropdownInput,
};

export const feature_synth_species: FeatureChoiced = {
  name: 'Synth Species',
  description: 'Determines what species you spawn disguised as.',
  component: FeatureDropdownInput,
};

export const feature_synth_damage_threshold: FeatureNumeric = {
  name: 'Synth Damage Threshold',
  description:
    'Determines how much damage you can take before your disguise is broken.',
  component: FeatureNumberInput,
};

export const feature_synth_blood: FeatureChoiced = {
  name: 'Synth Blood',
  description: 'Determines how your blood works.',
  component: FeatureDropdownInput,
};

export const feature_arm_wings: FeatureChoiced = {
  name: 'Arm Wings',
  component: FeatureDropdownInput,
};

export const feather_color: Feature<string> = {
  name: 'Feather Color',
  description:
    "The color of your character's feathers. \
  (Armwings, Plumage).",
  component: FeatureColorInput,
};

export const feature_avian_tail: FeatureChoiced = {
  name: 'Tail',
  component: FeatureDropdownInput,
};

export const feature_avian_ears: FeatureChoiced = {
  name: 'Plumage',
  component: FeatureDropdownInput,
};

export const feature_fish_tail: FeatureChoiced = {
  name: 'Fish Tail',
  component: FeatureDropdownInput,
};

export const feature_rat_tail: FeatureChoiced = {
  name: 'Rat Tail',
  component: FeatureDropdownInput,
};

export const feature_rat_ears: FeatureChoiced = {
  name: 'Rat Ears',
  component: FeatureDropdownInput,
};

export const feature_bat_wings: FeatureChoiced = {
  name: 'Bat Wings',
  component: FeatureDropdownInput,
};

export const feature_bat_ears: FeatureChoiced = {
  name: 'Bat Ears',
  component: FeatureDropdownInput,
};

export const feature_deer_ears: FeatureChoiced = {
  name: 'Deer Ears',
  component: FeatureDropdownInput,
};

export const feature_deer_tail: FeatureChoiced = {
  name: 'Deer Tail',
  component: FeatureDropdownInput,
};

export const feature_bunny_ears: FeatureChoiced = {
  name: 'Bunny Ears',
  component: FeatureDropdownInput,
};

export const feature_bunny_tail: FeatureChoiced = {
  name: 'Bunny Tail',
  component: FeatureDropdownInput,
};

export const feature_dog_ears: FeatureChoiced = {
  name: 'Dog Ears',
  component: FeatureDropdownInput,
};

export const feature_dog_tail: FeatureChoiced = {
  name: 'Dog Tail',
  component: FeatureDropdownInput,
};

export const feature_fox_ears: FeatureChoiced = {
  name: 'Fox Ears',
  component: FeatureDropdownInput,
};

export const feature_fox_tail: FeatureChoiced = {
  name: 'Fox Tail',
  component: FeatureDropdownInput,
};

export const feature_android_species: FeatureChoiced = {
  name: 'Android Species',
  description: 'Determines what species you are modeled after.',
  component: FeatureDropdownInput,
};

export const feature_android_emotionless: FeatureToggle = {
  name: 'Android Emotions',
  description: 'If unchecked, all moodlets have no effect on you.',
  component: CheckboxInput,
};

function AndroidLaws(
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) {
  const { data } = useBackend<PreferencesMenuData>();
  const server_data = useServerPrefs();

  const active_law = data.character_preferences.secondary_features
    .feature_android_laws as string | undefined;
  const tooltip = server_data?.laws.lawname_to_laws;

  return (
    <Stack>
      <Stack.Item>
        <Button
          height="100%"
          icon="book"
          tooltip={
            <Stack vertical>
              <Stack.Item>
                <b>Policy</b>:
              </Stack.Item>
              <Stack.Divider />
              <Stack.Item>
                &bull; Selecting 'Unlawed' grants free will like any other
                member of the crew. It does <b>not</b> make you an antagonist.
              </Stack.Item>
              <Stack.Item>
                &bull; Your laws are static, outside of rare circumstances.
                Other crewmembers <b>cannot</b> interfere with your laws the
                same way they can with normal silicons.
              </Stack.Item>
              <Stack.Item>
                &bull; Having laws doesn't automatically allow you to antagonize
                people who contradict them. While normal silicons can be
                relawed, <i>you</i> cannot - so give other crewmembers leniency.
              </Stack.Item>
              <Stack.Item>
                &bull; If you <b>are</b> an antagonist, you will be given a
                zeroeth law allowing you to ignore your other laws. However, you
                may choose to ignore it for an added challenge.
              </Stack.Item>
            </Stack>
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          height="100%"
          icon="info"
          disabled={!tooltip}
          tooltip={
            tooltip ? (
              <Stack vertical>
                <Stack.Item>
                  <b>{active_law || 'Unlawed'}</b>:
                </Stack.Item>
                <Stack.Divider />
                {active_law && tooltip[active_law] ? (
                  Object.entries(tooltip[active_law]).map(([id, law]) => (
                    <Stack.Item key={id}>{law}</Stack.Item>
                  ))
                ) : (
                  <Stack.Item>
                    You are unbound by laws, and have free will like any other
                    member of the crew.
                  </Stack.Item>
                )}
              </Stack>
            ) : (
              'The server is still loading, please wait.'
            )
          }
        />
      </Stack.Item>
      <Stack.Item grow>
        <FeatureDropdownInput {...props} />
      </Stack.Item>
    </Stack>
  );
}

export const feature_android_laws: FeatureChoiced = {
  name: 'Android Laws',
  description: `
    Determines what laws you are bound to follow.
    For more information about android laws, hover over the book icon.
    To see what the selected lawset entails, hover over the info icon.
  `,
  component: AndroidLaws,
};
