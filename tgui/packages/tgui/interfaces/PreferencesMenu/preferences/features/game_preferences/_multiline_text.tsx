import { Feature, FeatureValueProps } from '../base';
import { Stack, TextArea } from '../../../../../components';

export const MultilineText = (
  props: FeatureValueProps<string, string> & { box_height: string | null }
) => {
  const { handleSetValue, value } = props;
  return (
    <Stack>
      <Stack.Item grow>
        <TextArea
          width="80%"
          height={props.box_height || '36px'}
          value={value}
          onChange={(e, value) => {
            handleSetValue(value);
          }}
        />
      </Stack.Item>
    </Stack>
  );
};

export const flavor_text: Feature<string, string> = {
  name: 'Flavor - Flavor Text',
  description: 'A small snippet of text shown when others examine you, \
    describing what you may look like.',
  component: (props: FeatureValueProps<string, string>, context) => {
    return <MultilineText {...props} box_height="52px" />;
  },
};

export const silicon_text: Feature<string, string> = {
  name: 'Flavor - Silicon Flavor Text',
  description: 'Flavor text shown when you are placed into a cyborg or AI.',
  component: MultilineText,
};

export const exploitable_info: Feature<string, string> = {
  name: 'Flavor - Exploitable Info',
  description: 'Information about your character made available to \
    players who are antagonists. Can be used to give antagonists \
    more interesting ways of approaching your character.',
  component: MultilineText,
};

export const general_records: Feature<string, string> = {
  name: 'Flavor - General Records',
  description: 'Random information about your character\'s history. \
    Available in medical records consoles.',
  component: MultilineText,
};

export const security_records: Feature<string, string> = {
  name: 'Flavor - Security Records',
  description: 'Information about your character\'s criminal past. \
    Available in security records consoles.',
  component: MultilineText,
};

export const medical_records: Feature<string, string> = {
  name: 'Flavor - Medical Records',
  description: 'Information about your character\'s medical history. \
    Available in medical records consoles.',
  component: MultilineText,
};
