import { Component, createRef } from 'inferno';
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, BlockQuote, Button, Collapsible, Section, Stack } from '../components';
import { Window } from '../layouts';

const makeCategoryReadable = (cat: string | null): string | null => {
  switch (cat) {
    case 'chest':
      return 'Chest';
    case 'head':
      return 'Head';
    case 'l_arm':
      return 'Left Arm';
    case 'r_arm':
      return 'Right Arm';
    case 'l_leg':
      return 'Left Leg';
    case 'r_leg':
      return 'Right Leg';
    default:
      return null;
  }
};

const findCatInXYRange = (x: number, y: number): string | null => {
  if (y <= 72) {
    if (x >= 70 && x <= 150) {
      return 'head';
    }
  } else if (y <= 163) {
    if (x >= 47 && x <= 80) {
      return 'r_arm';
    } else if (x >= 81 && x <= 139) {
      return 'chest';
    } else if (x >= 140 && x <= 175) {
      return 'l_arm';
    }
  } else if (x >= 60 && x <= 109) {
    return 'r_leg';
  } else if (x >= 110 && x <= 159) {
    return 'l_leg';
  }
  return null;
};

type Data = {
  limbs: LimbCategory[];
  selected_limbs: string[];
  preview_flat_icon: string;
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
          <Collapsible
            title={makeCategoryReadable(limb_category.category_name)}>
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

type PreviewProps = {
  preview_flat_icon: string;
};

type PreviewState = {
  mouseX: number;
  mouseY: number;
  selected: string | null;
};

class LimbPreview extends Component<PreviewProps, PreviewState> {
  ref = createRef<HTMLDivElement>();
  state: PreviewState = {
    mouseX: -1,
    mouseY: -1,
    selected: null,
  };

  render() {
    const { mouseX, mouseY, selected } = this.state;
    const { preview_flat_icon } = this.props;

    const current_cat = findCatInXYRange(mouseX, mouseY);

    const width = '224px';
    const height = '224px';

    return (
      <Stack vertical fill>
        <Stack.Item grow>
          <div
            ref={this.ref}
            style={{
              width: '100%',
              height: '100%',
              position: 'relative',
            }}>
            <Box
              as="img"
              m={1}
              src={`data:image/jpeg;base64,${preview_flat_icon}`}
              height={width}
              width={height}
              style={{
                '-ms-interpolation-mode': 'nearest-neighbor',
                'position': 'absolute',
              }}
              onMouseDown={(event) => {
                const rect = this.ref.current?.getBoundingClientRect();
                if (!rect) {
                  return;
                }
                const newX = event.clientX - rect.left;
                const newY = event.clientY - rect.top;
                this.setState({
                  mouseX: newX,
                  mouseY: newY,
                  selected: findCatInXYRange(newX, newY),
                });
              }}
              onMouseMove={(event) => {
                const rect = this.ref.current?.getBoundingClientRect();
                if (!rect) {
                  return;
                }
                this.setState({
                  mouseX: event.clientX - rect.left,
                  mouseY: event.clientY - rect.top,
                });
              }}
            />
            {selected && (
              <Box
                as="img"
                m={1}
                src={resolveAsset(`body_zones.${selected}.png`)}
                height={width}
                width={height}
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  'pointer-events': 'none',
                  'position': 'absolute',
                }}
              />
            )}
            {current_cat && current_cat !== selected && (
              <Box
                as="img"
                m={1}
                src={resolveAsset(`body_zones.${current_cat}.png`)}
                height={width}
                width={height}
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  'pointer-events': 'none',
                  'position': 'absolute',
                  'opacity': 0.5,
                }}
              />
            )}
          </div>
        </Stack.Item>
        <Stack.Item>Selected: {makeCategoryReadable(selected)}</Stack.Item>
        <Stack.Item>Hovered: {makeCategoryReadable(current_cat)}</Stack.Item>
      </Stack>
    );
  }
}

export const _LimbManager = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { limbs, selected_limbs, preview_flat_icon } = data;

  return (
    <Window title="Limb Manager" width={700} height={365}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width={20}>
            <Section title="Preview" fill align="center">
              <LimbPreview preview_flat_icon={preview_flat_icon} />
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
