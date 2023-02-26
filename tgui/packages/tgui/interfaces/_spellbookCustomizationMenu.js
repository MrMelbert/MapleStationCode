import { useBackend } from '../backend';
import { Input, NumberInput, Section, Slider, Stack } from '../components';
import { Window } from '../layouts';
import { Button } from '../components';

export const _spellbookCustomizationMenu = (props, context) => {
  const { act, data } = useBackend(context);

  const { entries } = data;

  return (
    <Window title="Customization" width={600} height={900}>
      <Window.Content height="100%">
        <Stack fill vertical scrollable>
          <Section scrollable>
            {entries.map((element) => (
              <Stack.Item key={element.key}>
                {element.name + ': '}
                {element.interfacetype === 'slider' && (
                  <Slider
                    value={element.current_value}
                    minValue={element.min_value}
                    maxValue={element.max_value}
                    step={element.min_increment}
                    stepPixelSize={6}
                    content={element.name}
                    onChange={(e, value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: value,
                      })
                    }
                  />
                )}
                {element.interfacetype === 'boolean' && (
                  <Button.Checkbox
                    content={element.name}
                    checked={!!element.current_value === true}
                    onClick={() =>
                      act('change_value', {
                        key: element.key,
                        new_value: !element.current_value,
                      })
                    }
                  />
                )}
                {element.interfacetype === 'any_input' && (
                  <Input
                    content={element.name}
                    value={element.current_value}
                    onChange={(e, value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: value,
                      })
                    }
                  />
                )}
                {element.interfacetype === 'number_input' && (
                  <NumberInput
                    content={element.name}
                    value={element.current_value}
                    minValue={element.min_value}
                    maxValue={element.max_value}
                    step={element.min_increment}
                    stepPixelSize={element.min_increment}
                    onChange={(e, value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: value,
                      })
                    }
                  />
                )}
              </Stack.Item>
            ))}
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
