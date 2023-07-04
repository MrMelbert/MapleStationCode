import { useBackend } from '../backend';
import { BlockQuote, Button, Collapsible, Section, Stack } from '../components';
import { Window } from '../layouts';
import { CharacterPreview } from './common/CharacterPreview';

const CAT_TO_READABLE = {
  'chest': 'Chest',
  'head': 'Head',
  'l_arm': 'Left Arm',
  'r_arm': 'Right Arm',
  'l_leg': 'Left Leg',
  'r_leg': 'Right Leg',
};

type Data = {
  limbs: LimbCategory[];
  selected_limbs: string[];
  character_preview_view: string;
};

type LimbCategory = {
  category_name: string;
  category_data: Limb[];
};

type Limb = {
  name: string;
  tooltip: string;
  path: string;
};

const LimbSelectButton = (
  props: { select_limb: Limb; selected_limbs: string[] },
  context
) => {
  const { act, data } = useBackend<Limb>(context);
  const { select_limb, selected_limbs } = props;
  const is_active = selected_limbs.includes(select_limb.path);
  return (
    <Button.Checkbox
      checked={is_active}
      content={select_limb.name}
      tooltip={select_limb.tooltip}
      tooltipPosition="right"
      onClick={() =>
        act(is_active ? 'deselect_path' : 'select_path', {
          path_to_use: select_limb.path,
        })
      }
    />
  );
};

const DisplayLimbs = (
  props: { selected_limbs: string[]; limbs: LimbCategory[] },
  context
) => {
  const { data } = useBackend<LimbCategory>(context);
  const { selected_limbs, limbs } = props;

  return (
    <Stack vertical fill>
      {limbs.map((limb_category, index) => (
        <Stack.Item key={index}>
          <Collapsible title={CAT_TO_READABLE[limb_category.category_name]}>
            <Stack vertical>
              {limb_category.category_data.length ? (
                limb_category.category_data.map((limb, index) => (
                  <Stack.Item key={index}>
                    <LimbSelectButton
                      select_limb={limb}
                      selected_limbs={selected_limbs}
                    />
                  </Stack.Item>
                ))
              ) : (
                <Stack.Item>
                  <BlockQuote>No limbs available for this bodypart.</BlockQuote>
                </Stack.Item>
              )}
            </Stack>
          </Collapsible>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const LimbPreview = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  return (
    <Stack vertical fill>
      <Stack.Item grow align="center">
        <CharacterPreview height="100%" id={data.character_preview_view} />
      </Stack.Item>
      <Stack.Item align="center">
        <Stack>
          <Stack.Item>
            <Button
              icon="chevron-left"
              onClick={() =>
                act('rotate_dummy', {
                  dir: 'left',
                })
              }
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="chevron-right"
              onClick={() =>
                act('rotate_dummy', {
                  dir: 'right',
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const _LimbManager = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { limbs, selected_limbs } = data;

  return (
    <Window title="Limb Manager" width={700} height={500}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width={20}>
            <Section title="Preview" fill align="center">
              <LimbPreview />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Augments" fill scrollable>
              <DisplayLimbs limbs={limbs} selected_limbs={selected_limbs} />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
