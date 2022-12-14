import { useBackend } from '../backend';
import { Button, Dropdown, Input, LabeledList, Stack, TextArea } from '../components';
import { AdvancedTraitorBackgroundSection } from './_AdvancedTraitorParts';
import { AdvancedTraitorWindow } from './_AdvancedTraitorParts';
import { AdvancedTraitorGoalsSection } from './_AdvancedTraitorParts';

export const _AdvancedCultPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { goals_finalized, can_convert } = data;

  return (
    <AdvancedTraitorWindow theme="abductor">
      <AdvancedTraitorBackgroundSection>
        <AdvancedCultBackground />
      </AdvancedTraitorBackgroundSection>
      <AdvancedTraitorGoalsSection>
        <Button.Checkbox
          height="20px"
          content="Enable Conversion"
          textAlign="center"
          disabled={goals_finalized}
          checked={can_convert}
          tooltip="If checked, the ability to convert will be enabled. \
            Disabling conversion rewards +1 max spell slots."
          onClick={() => act('toggle_conversion')}
        />
      </AdvancedTraitorGoalsSection>
    </AdvancedTraitorWindow>
  );
};

export const AdvancedCultBackground = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    employer,
    backstory,
    cult_style,
    cult_style_options = [],
    goals_finalized,
  } = data;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack>
          <Stack.Item width="50%">
            <LabeledList align="center">
              <LabeledList.Item label="Title">
                <Input
                  width="90%"
                  value={name}
                  placeholder={name}
                  onInput={(e, value) =>
                    act('set_name', {
                      name: value,
                    })
                  }
                />
              </LabeledList.Item>
              <LabeledList.Item label="Diety">
                <Input
                  width="90%"
                  value={employer}
                  placeholder={employer}
                  onInput={(e, value) =>
                    act('set_employer', {
                      employer: value,
                    })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item width="40%">
            <LabeledList align="center">
              <LabeledList.Item label="Cult Style">
                <Dropdown
                  width="100%"
                  selected={cult_style}
                  options={cult_style_options}
                  disabled={goals_finalized}
                  onSelected={(value) =>
                    act('set_cult_style', {
                      cult_style: value,
                    })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item>
        <LabeledList align="center">
          <LabeledList.Item label="Backstory">
            <TextArea
              width="66%"
              height="54px"
              value={backstory}
              placeholder={backstory}
              onInput={(e, value) =>
                act('set_backstory', {
                  backstory: value,
                })
              }
            />
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
