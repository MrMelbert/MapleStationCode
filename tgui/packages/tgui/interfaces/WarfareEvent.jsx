import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const WarfareEvent = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const { selectedShells, fireDirection } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Health status">
          <LabeledList>
            <LabeledList.Item label="selectedShells">
              {selectedShells}
            </LabeledList.Item>
            <LabeledList.Item label="fireDirection">
              {fireDirection}
            </LabeledList.Item>
            <LabeledList.Item label="Button">
              <Button
                content="Dispatch a 'fireShells' action"
                onClick={() => act('fireShells')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
