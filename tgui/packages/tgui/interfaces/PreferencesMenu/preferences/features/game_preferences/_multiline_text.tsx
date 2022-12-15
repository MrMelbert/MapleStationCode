import { Feature, FeatureValueProps } from '../base';
import { Stack, TextArea } from '../../../../../components';

export const MultilineText = (props: FeatureValueProps<string, string>) => {
  const { handleSetValue, value } = props;
  return (
    <Stack>
      <Stack.Item grow>
        <TextArea
          width="80%"
          height="52px"
          value={value}
          onInput={(e, value) => {
            handleSetValue(value);
          }}
        />
      </Stack.Item>
    </Stack>
  );
};

export const flavor_text: Feature<string, string> = {
  name: 'Flavor - Flavor Text',
  component: MultilineText,
};

export const exploitable_info: Feature<string, string> = {
  name: 'Flavor - Exploitable Info',
  component: MultilineText,
};

export const general_records: Feature<string, string> = {
  name: 'Flavor - General Records',
  component: MultilineText,
};

export const security_records: Feature<string, string> = {
  name: 'Flavor - Security Records',
  component: MultilineText,
};

export const medical_records: Feature<string, string> = {
  name: 'Flavor - Medical Records',
  component: MultilineText,
};
