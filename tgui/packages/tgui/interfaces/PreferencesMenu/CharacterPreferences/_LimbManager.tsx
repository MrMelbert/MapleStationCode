import { Component, createRef } from 'react';
import {
  BlockQuote,
  Button,
  Icon,
  Image,
  ImageButton,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { capitalizeFirst } from 'tgui-core/string';

import { resolveAsset } from '../../../assets';
import { useBackend } from '../../../backend';
import { Connection, Connections } from '../../common/Connections';
import { useServerPrefs } from '../useServerPrefs';

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
      return `${capitalizeFirst(cat)}:`;
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

const listPos = { x: 240, y: 50 };

const catToPos = (cat: string | null): { x: number; y: number } => {
  switch (cat) {
    case 'chest':
      return { x: 115, y: 110 };
    case 'head':
      return { x: 115, y: 50 };
    case 'l_arm':
      return { x: 165, y: 120 };
    case 'r_arm':
      return { x: 65, y: 120 };
    case 'l_leg':
      return { x: 130, y: 190 };
    case 'r_leg':
      return { x: 95, y: 190 };
    default:
      return { x: -1, y: -1 };
  }
};

type bodypartPath = string;
type limbDatumPath = string;

type Data = {
  // limbs: LimbCategory[];
  selected_limbs: string[] | null;
  preview_flat_icon: string;
  unavailable_paths: limbDatumPath[];
};

export type LimbCategory = {
  category_name: string;
  category_data: Limb[];
};

type Limb = {
  name: string;
  tooltip: string;
  path: bodypartPath;
  datum_type: limbDatumPath;
  ui_icon: string;
  ui_icon_state: string;
  is_bodypart: BooleanLike;
};

const LimbSelectButton = (props: {
  select_limb: Limb;
  selected_limbs: string[] | null;
}) => {
  const { act, data } = useBackend<Data>();
  const { select_limb, selected_limbs } = props;
  const { unavailable_paths } = data;
  const is_active = selected_limbs?.includes(select_limb.path);
  const is_disabled = unavailable_paths.includes(select_limb.datum_type);
  return (
    <div style={{ position: 'relative' }}>
      <ImageButton
        dmIcon={select_limb.ui_icon}
        dmIconState={select_limb.ui_icon_state}
        imageSize={64}
        color={is_active ? 'green' : is_disabled ? 'red' : 'default'}
        tooltip={select_limb.name}
        disabled={is_disabled}
        tooltipPosition="bottom"
        onClick={() =>
          act(is_active ? 'deselect_path' : 'select_path', {
            path_to_use: select_limb.path,
          })
        }
      />
      <div
        style={{ position: 'absolute', top: '8px', right: '12px', zIndex: '2' }}
      >
        {select_limb.tooltip && (
          <Stack vertical>
            <Stack.Item
              key={select_limb.tooltip}
              fontSize="14px"
              textColor={'darkgray'}
              bold
            >
              <Tooltip position="right" content={select_limb.tooltip}>
                <Icon name={'info'} />
              </Tooltip>
            </Stack.Item>
          </Stack>
        )}
      </div>
    </div>
  );
};

const DisplayLimbsInner = (props: {
  selected_limbs: string[] | null;
  limb_category: LimbCategory;
}) => {
  const { selected_limbs, limb_category } = props;

  const category_data_bodyparts_only = limb_category.category_data
    .filter((limb) => limb.is_bodypart)
    .sort((a, b) => (a.name > b.name ? 1 : -1));
  const category_data_non_bodyparts_only = limb_category.category_data
    .filter((limb) => !limb.is_bodypart)
    .sort((a, b) => (a.name > b.name ? 1 : -1));

  return (
    <>
      <Stack.Item>
        <Section
          title={`${makeCategoryReadable(limb_category.category_name)} Bodyparts`}
        >
          <Stack wrap>
            {category_data_bodyparts_only.length ? (
              category_data_bodyparts_only.map((limb, index) => (
                <Stack.Item key={index}>
                  <LimbSelectButton
                    select_limb={limb}
                    selected_limbs={selected_limbs}
                  />
                </Stack.Item>
              ))
            ) : (
              <Stack.Item>
                <BlockQuote>No bodyparts available.</BlockQuote>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title={`${makeCategoryReadable(limb_category.category_name)} Organs`}
        >
          <Stack wrap>
            {category_data_non_bodyparts_only.length ? (
              category_data_non_bodyparts_only.map((limb, index) => (
                <Stack.Item key={index}>
                  <LimbSelectButton
                    select_limb={limb}
                    selected_limbs={selected_limbs}
                  />
                </Stack.Item>
              ))
            ) : (
              <Stack.Item>
                <BlockQuote>No organs available.</BlockQuote>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </>
  );
};

const DisplayLimbs = (props: {
  selected_limbs: string[] | null;
  limbs: LimbCategory | null;
}) => {
  const { selected_limbs, limbs } = props;

  return (
    <Stack vertical fill>
      {limbs ? (
        <DisplayLimbsInner
          selected_limbs={selected_limbs}
          limb_category={limbs}
        />
      ) : (
        <Stack.Item>
          <BlockQuote>Click on a body part to select it.</BlockQuote>
        </Stack.Item>
      )}
    </Stack>
  );
};

type PreviewProps = {
  preview_flat_icon: string;
  selected_cat: string | null;
  selected_limbs: string[] | null;
  all_limbs: LimbCategory[];
  onSelect?: (selected: string | null) => void;
};

type PreviewState = {
  mouseX: number;
  mouseY: number;
};

class LimbPreview extends Component<PreviewProps, PreviewState> {
  ref = createRef<HTMLDivElement>();
  state: PreviewState = {
    mouseX: -1,
    mouseY: -1,
  };

  render() {
    const { mouseX, mouseY } = this.state;
    const {
      preview_flat_icon,
      selected_cat,
      selected_limbs,
      all_limbs,
      onSelect,
    } = this.props;
    const { act } = useBackend<Data>();

    const current_cat = findCatInXYRange(mouseX, mouseY);

    const width = '224px';
    const height = '224px';

    const updateXYState = (event) => {
      const rect = this.ref.current?.getBoundingClientRect();
      if (!rect) {
        return { x: -1, y: -1 };
      }
      const newX = event.clientX - rect.left;
      const newY = event.clientY - rect.top;
      this.setState({
        mouseX: newX,
        mouseY: newY,
      });

      return { x: newX, y: newY };
    };

    return (
      <Stack vertical fill>
        <Stack.Item grow>
          <div
            ref={this.ref}
            style={{
              width: '100%',
              height: '100%',
              zIndex: '1',
            }}
          >
            <Image
              m={1}
              src={`data:image/jpeg;base64,${preview_flat_icon}`}
              height={width}
              width={height}
              fixBlur
              style={{
                zIndex: '1',
              }}
              onClick={(event) => {
                const { x, y } = updateXYState(event);
                if (onSelect) {
                  onSelect(findCatInXYRange(x, y));
                }
              }}
              onMouseMove={(event) => {
                updateXYState(event);
              }}
            />
            {selected_cat && (
              <Image
                m={1}
                src={resolveAsset(`body_zones.${selected_cat}.png`)}
                height={width}
                width={height}
                fixBlur
                style={{
                  pointerEvents: 'none',
                  position: 'absolute',
                  zIndex: '3',
                  opacity: '0.3',
                  left: '6px',
                  top: '9px',
                }}
              />
            )}
            {current_cat && current_cat !== selected_cat && (
              <Image
                m={1}
                src={resolveAsset(`body_zones.${current_cat}.png`)}
                height={width}
                width={height}
                fixBlur
                style={{
                  pointerEvents: 'none',
                  position: 'absolute',
                  zIndex: '2',
                  opacity: '0.2',
                  left: '6px',
                  top: '9px',
                }}
              />
            )}
          </div>
        </Stack.Item>
        <Stack.Item grow>
          <Section scrollable fill>
            <Stack vertical textAlign="left">
              {!!selected_limbs?.length &&
                selected_limbs.map((limb, index) => (
                  <Stack.Item
                    key={index}
                    textColor={'darkgray'}
                    className="candystripe"
                    p={1}
                  >
                    <Stack>
                      <Stack.Item grow>
                        {all_limbs
                          .flatMap((cat) => cat.category_data)
                          .find((l) => l.path === limb)?.name || limb}
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="times"
                          color="transparent"
                          onClick={() =>
                            act('deselect_path', { path_to_use: limb })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    );
  }
}

type LimbManagerInnerProps = {
  limbs: LimbCategory[];
  selected_limbs: string[] | null;
  preview_flat_icon: string;
};

type LimbManagerInnerState = {
  current_selection: string | null;
  limbSearchQuery: string;
};

class LimbManagerInner extends Component<
  LimbManagerInnerProps,
  LimbManagerInnerState
> {
  ref = createRef<HTMLDivElement>();
  state: LimbManagerInnerState = {
    current_selection: 'chest',
    limbSearchQuery: '',
  };

  render() {
    const { current_selection, limbSearchQuery } = this.state;
    const { limbs, selected_limbs, preview_flat_icon } = this.props;

    const connections: Connection[] = [];
    if (current_selection) {
      const newPos = catToPos(current_selection);
      newPos.x = newPos.x + 8;
      newPos.y = newPos.y + 48;
      const newConnection: Connection = {
        color: 'red',
        from: newPos,
        to: listPos,
      };

      connections.push(newConnection);
    }

    const searchFn = (limb: Limb) => {
      if (!limbSearchQuery) {
        return true;
      }
      return limb.name.toLowerCase().includes(limbSearchQuery.toLowerCase());
    };

    // makes a category with the name "search results" and the contents of all categories that match the search query
    function buildSearchCategory() {
      const results: Limb[] = [];
      for (const cat of limbs) {
        for (const limb of cat.category_data) {
          if (searchFn(limb)) {
            results.push(limb);
          }
        }
      }
      return { category_name: 'search results', category_data: results };
    }

    function findCatFromSelection() {
      for (const cat of limbs) {
        if (cat.category_name === current_selection) {
          return cat;
        }
      }
      return null;
    }

    return (
      <>
        <Connections connections={connections} zLayer={4} lineWidth={4} />
        <Stack height="500px">
          <Stack.Item width={20}>
            <Section title="Preview" fill align="center">
              <LimbPreview
                preview_flat_icon={preview_flat_icon}
                selected_cat={current_selection}
                selected_limbs={selected_limbs}
                all_limbs={limbs}
                onSelect={(new_selection) =>
                  this.setState({ current_selection: new_selection })
                }
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="&nbsp;"
              fill
              scrollable
              buttons={
                <Input
                  placeholder="Search Limbs"
                  value={limbSearchQuery}
                  onInput={(e, value) =>
                    this.setState({ limbSearchQuery: value })
                  }
                  width={16}
                />
              }
            >
              {limbSearchQuery.length > 1 ? (
                <DisplayLimbs
                  limbs={buildSearchCategory()}
                  selected_limbs={selected_limbs}
                />
              ) : (
                <DisplayLimbs
                  limbs={findCatFromSelection()}
                  selected_limbs={selected_limbs}
                />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </>
    );
  }
}

export const LimbManagerPage = () => {
  const { data } = useBackend<Data>();

  const server_data = useServerPrefs();

  return server_data ? (
    <LimbManagerInner
      limbs={server_data.limbs.limbs}
      selected_limbs={data.selected_limbs}
      preview_flat_icon={data.preview_flat_icon}
    />
  ) : (
    <NoticeBox>Loading...</NoticeBox>
  );
};
