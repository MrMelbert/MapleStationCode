import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

export const WarfareEvent = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const { selectedShells, fireDirection } = data;
  return (
    <Window title="Warfare Module" resizable>
      <Window.Content scrollable>
        <Section title="Volley Configuration">
          <Button
            fluid
            icon="bomb"
            color="bad"
            content="Fire Volley"
            onClick={() => act('fireShells')}
          />
          <Section title="Loaded Shells" />
        </Section>
      </Window.Content>
    </Window>
  );
};
