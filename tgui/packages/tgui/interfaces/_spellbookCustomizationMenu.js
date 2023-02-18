import { useBackend } from '../backend';
import { Input, Section, Slider, Stack } from '../components';
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
            {Array.from(entries)[1].key}
            {entries.map((element) => (
              <Stack.Item key={element.key}>
                {element.name + ':'}
                {element.interfacetype === 'slider' && (
                  <Slider
                    value={element.current_value}
                    minValue={element.min_value}
                    maxValue={element.max_value}
                    step={element.min_increments}
                    stepPixelSize={element.min_increments}
                    content={element.name}
                    onChange={(new_value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: new_value,
                      })
                    }
                  />
                )}
                {element.interfacetype === 'boolean' && (
                  <Button.Checkbox
                    content={element.name}
                    checked={!!element.current_value}
                    onChange={(new_value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: new_value,
                      })
                    }
                  />
                )}
                {element.interfacetype === 'input' && (
                  <Input
                    content={element.name}
                    value={element.current_value}
                    onChange={(new_value) =>
                      act('change_value', {
                        key: element.key,
                        new_value: new_value,
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
