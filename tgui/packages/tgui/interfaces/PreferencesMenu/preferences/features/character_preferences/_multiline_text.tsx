import { TextArea } from 'tgui-core/components';

import type { FeatureMultiline, FeatureMultilineProps } from '../base';

export function MultilineText(
  props: FeatureMultilineProps & {
    box_height: string | null;
  },
) {
  const { serverData, handleSetValue, value, box_height } = props;

  return (
    <TextArea
      disabled={!serverData}
      width="80%"
      height={box_height || '36px'}
      value={value}
      maxLength={serverData?.maximum_length || 1024}
      onBlur={handleSetValue}
    />
  );
}

export const flavor_text: FeatureMultiline = {
  name: 'Flavor - Flavor Text',
  description:
    'A small snippet of text shown when others examine you, \
    describing what you may look like.',
  component: (props: FeatureMultilineProps) => {
    return <MultilineText {...props} box_height="52px" />;
  },
};

export const silicon_text: FeatureMultiline = {
  name: 'Flavor - Silicon Flavor Text',
  description: 'Flavor text shown when you are placed into a cyborg or AI.',
  component: MultilineText,
};

export const exploitable_info: FeatureMultiline = {
  name: 'Flavor - Exploitable Info',
  description:
    'Information about your character made available to \
    players who are antagonists. Can be used to give antagonists \
    more interesting ways of approaching your character.',
  component: MultilineText,
};

export const general_records: FeatureMultiline = {
  name: 'Flavor - General Records',
  description:
    "Random information about your character's history. \
    Available in medical records consoles.",
  component: MultilineText,
};

export const security_records: FeatureMultiline = {
  name: 'Flavor - Security Records',
  description:
    "Information about your character's criminal past. \
    Available in security records consoles.",
  component: MultilineText,
};

export const medical_records: FeatureMultiline = {
  name: 'Flavor - Medical Records',
  description:
    "Information about your character's medical history. \
    Available in medical records consoles.",
  component: MultilineText,
};
