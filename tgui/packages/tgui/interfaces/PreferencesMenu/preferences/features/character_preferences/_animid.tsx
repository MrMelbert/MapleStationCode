import { useState } from 'react';
import { Box, Button, Floating, Stack } from 'tgui-core/components';
import { capitalizeFirst } from 'tgui-core/string';
import { useBackend } from '../../../../../backend';
import {
  DietStack,
  SpeciesPerks,
} from '../../../CharacterPreferences/SpeciesPage';
import type { Diet, PreferencesMenuData, Species } from '../../../types';
import type { Feature, FeatureValueProps } from '../base';

type AnimidType = {
  id: string;
  name: string;
  perks: Species['perks'];
  components: string[];
  icon: string;
  diet: Diet | null;
};

type AnimidServerData = {
  animid_customization: Record<string, AnimidType>;
};

const AnimidPref = 'animid_type';

const AnimidSelection = (
  props: FeatureValueProps<number, number, AnimidServerData>,
) => {
  const { data } = useBackend<PreferencesMenuData>();
  const { serverData } = props;
  const { secondary_features } = data.character_preferences;
  const [uiOpen, setUiOpen] = useState(false);
  const selected = secondary_features[AnimidPref] as string;
  const selected_name = serverData?.animid_customization[selected]?.name;
  return (
    <Floating
      stopChildPropagation
      placement="bottom"
      onOpenChange={setUiOpen}
      content={
        uiOpen &&
        !!serverData && (
          <Box
            onClick={(e) => {
              e.stopPropagation();
            }}
            className="ChoicedSelection"
            style={{
              padding: '5px',
              overflowY: 'scroll',
              left: '80px',
              position: 'relative',
            }}
          >
            {AnimidSelectionInner(serverData, selected)}
          </Box>
        )
      }
    >
      <Button
        onClick={() => setUiOpen(!uiOpen)}
        selected={uiOpen}
        disabled={!serverData}
      >
        {selected_name ?? 'Unknown'}
      </Button>
    </Floating>
  );
};

function AnimidSelectionInner(serverData: AnimidServerData, selected: string) {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack vertical maxHeight="500px">
      {Object.entries(serverData.animid_customization)
        .sort((a, b) => {
          return a[1].name < b[1].name ? -1 : 1;
        })
        .map(([id, option]) => {
          return (
            <Stack.Item key={id}>
              <Stack
                minWidth="400px"
                p={1}
                className="candystripe"
                style={{
                  borderRadius: '4px',
                }}
              >
                <Stack.Item width="25%">
                  <Stack vertical align="center" ml={1} fill>
                    <Stack.Item fontSize={'16px'}>
                      <i>{option.name}</i>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon={option.icon}
                        iconSize={4}
                        p={1}
                        style={{
                          cursor: 'pointer',
                          borderColor:
                            selected === option.id ? 'green' : 'transparent',
                          borderStyle: 'solid',
                          borderWidth: '0.2em',
                          borderRadius: '0.33em',
                        }}
                        onClick={() => {
                          act('set_preference', {
                            preference: AnimidPref,
                            value: id,
                          });
                        }}
                        selected={selected === option.id}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item grow>
                  <Stack fill vertical ml={1}>
                    {option.components.length > 0 && (
                      <Stack.Item textAlign="center">
                        <b>Features:</b>{' '}
                        {option.components
                          .map((c) => capitalizeFirst(c))
                          .sort()
                          .join(', ')}
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <DietStack diet={option.diet} />
                    </Stack.Item>
                    <Stack.Item>
                      <SpeciesPerks perks={option.perks} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          );
        })}
    </Stack>
  );
}

type FeatureAnimid = Feature<number, number, AnimidServerData>;

export const animid_type: FeatureAnimid = {
  name: 'Animid Type',
  description:
    'Select the type of animid you would like to play as. \
    Each type has its own advantages and disadvantages.',
  component: AnimidSelection,
};
