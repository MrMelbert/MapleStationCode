import {
  Box,
  Button,
  Flex,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../../backend';
import { useServerPrefs } from '../useServerPrefs';

type typePath = string;

type languagePath = typePath;

type Data = {
  pref_name: string;
  spoken_languages: languagePath[];
  understood_languages: languagePath[];
  partial_languages: Record<languagePath, number>[];
  pref_spoken_languages: languagePath[];
  pref_understood_languages: languagePath[];
  pref_unspoken_languages: languagePath[];
  pref_ununderstood_languages: languagePath[];
};

export type Language = {
  name: string;
  desc: string;
  type: languagePath;
  unlocked: BooleanLike;
};

enum LanguageState {
  DEFAULT,
  DISABLED,
  ENABLED,
  NONE,
}

const StateToIcon = {
  [LanguageState.DEFAULT]: 'square-check-o',
  [LanguageState.DISABLED]: 'square-minus-o',
  [LanguageState.ENABLED]: 'square-plus-o',
  [LanguageState.NONE]: 'square-o',
};

function StateToColorDisabled(state: LanguageState, disabled: boolean) {
  if (disabled && state === LanguageState.NONE) {
    return 'grey';
  }
  return StateToColor[state];
}

const StateToColor = {
  [LanguageState.DEFAULT]: 'good',
  [LanguageState.DISABLED]: 'bad',
  [LanguageState.ENABLED]: 'average',
  [LanguageState.NONE]: 'default',
};

const StateToTooltipSpeech = {
  [LanguageState.DEFAULT]: 'You innately speak this.',
  [LanguageState.DISABLED]: 'You have opted out of speaking this.',
  [LanguageState.ENABLED]: 'You have chosen to speak this.',
  [LanguageState.NONE]: 'You do not speak this.',
};

const StateToTooltipUnderstanding = {
  [LanguageState.DEFAULT]: 'You innately understand this.',
  [LanguageState.DISABLED]: 'You have opted out of understanding this.',
  [LanguageState.ENABLED]: 'You have chosen to understand this.',
  [LanguageState.NONE]: 'You do not understand this.',
};

const get_spoken_language_state = (
  langtype: languagePath,
  data: Data,
): LanguageState => {
  if (data.pref_unspoken_languages.includes(langtype)) {
    return LanguageState.DISABLED;
  }
  if (data.pref_spoken_languages.includes(langtype)) {
    return LanguageState.ENABLED;
  }
  if (data.spoken_languages.includes(langtype)) {
    return LanguageState.DEFAULT;
  }
  return LanguageState.NONE;
};

const get_understood_language_state = (
  langtype: languagePath,
  data: Data,
): LanguageState => {
  if (data.pref_ununderstood_languages.includes(langtype)) {
    return LanguageState.DISABLED;
  }
  if (data.pref_understood_languages.includes(langtype)) {
    return LanguageState.ENABLED;
  }
  if (data.understood_languages.includes(langtype)) {
    return LanguageState.DEFAULT;
  }
  return LanguageState.NONE;
};

// Returns the keys for the spoken language button action based on the given language and data
const get_spoken_button_keys = (langtype: languagePath, data: Data) => {
  if (data.spoken_languages.includes(langtype)) {
    return {
      lang_key: 'Remove spoken language', // Corresponds to DM defines
      deselecting: data.pref_unspoken_languages.includes(langtype),
    };
  }
  return {
    lang_key: 'Add spoken language', // Corresponds to DM defines
    deselecting: data.pref_spoken_languages.includes(langtype),
  };
};

// Returns the keys for the understood language button action based on the given language and data
const get_understood_button_keys = (langtype: languagePath, data: Data) => {
  if (data.understood_languages.includes(langtype)) {
    return {
      lang_key: 'Remove understood language', // Corresponds to DM defines
      deselecting: data.pref_ununderstood_languages.includes(langtype),
    };
  }
  return {
    lang_key: 'Add understood language', // Corresponds to DM defines
    deselecting: data.pref_understood_languages.includes(langtype),
  };
};

const partial_understanding_percent = (langtype: languagePath, data: Data) => {
  if (!data.partial_languages[langtype]) {
    return null;
  }
  const all_understood_combined = data.understood_languages
    .concat(data.pref_understood_languages)
    .filter((item) => !data.pref_ununderstood_languages.includes(item));
  if (all_understood_combined.includes(langtype)) {
    return (
      <Box color="grey">
        <Tooltip content="You fully understand this language.">
          <s>{`${data.partial_languages[langtype]}%`}</s>
        </Tooltip>
      </Box>
    );
  }
  return <Box>{data.partial_languages[langtype]}%</Box>;
};

const LanguageRow = (props: {
  displayed_language: Language;
  spoken_cap: number;
  understood_cap: number;
}) => {
  const { act, data } = useBackend<Data>();
  const { displayed_language, spoken_cap, understood_cap } = props;
  const {
    spoken_languages,
    pref_spoken_languages,
    pref_unspoken_languages,
    understood_languages,
    pref_understood_languages,
    pref_ununderstood_languages,
  } = data;

  const lang_type = displayed_language.type;

  const spoken_state = get_spoken_language_state(lang_type, data);
  const understood_state = get_understood_language_state(lang_type, data);

  const ignore_spoken_cap = spoken_languages
    .concat(pref_spoken_languages)
    .concat(pref_unspoken_languages)
    .includes(lang_type);

  const ignore_undersood_cap = understood_languages
    .concat(pref_understood_languages)
    .concat(pref_ununderstood_languages)
    .includes(lang_type);

  // name - spoken - understood - partial understanding percent
  return (
    <Flex p={0.25} className="candystripe" align="center">
      <Flex.Item width="33%">
        {displayed_language.desc ? (
          <Tooltip content={displayed_language.desc} position="bottom-start">
            <Box
              inline
              style={{
                borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
              }}
            >
              {displayed_language.name}
            </Box>
          </Tooltip>
        ) : (
          <Box>{displayed_language.name}</Box>
        )}
      </Flex.Item>
      <Flex.Item grow>
        <Button
          disabled={
            !displayed_language.unlocked ||
            (pref_spoken_languages.length >= spoken_cap && !ignore_spoken_cap)
          }
          icon={StateToIcon[spoken_state]}
          color={StateToColorDisabled(
            spoken_state,
            !displayed_language.unlocked ||
              (pref_spoken_languages.length >= spoken_cap &&
                !ignore_spoken_cap),
          )}
          tooltip={StateToTooltipSpeech[spoken_state]}
          tooltipPosition={'right'}
          onClick={() =>
            act('set_language', {
              lang_type: lang_type,
              ...get_spoken_button_keys(lang_type, data),
            })
          }
        />
      </Flex.Item>
      <Flex.Item grow>
        <Button
          disabled={
            !displayed_language.unlocked ||
            (pref_understood_languages.length >= understood_cap &&
              !ignore_undersood_cap)
          }
          icon={StateToIcon[understood_state]}
          color={StateToColorDisabled(
            understood_state,
            !displayed_language.unlocked ||
              (pref_understood_languages.length >= understood_cap &&
                !ignore_undersood_cap),
          )}
          tooltip={StateToTooltipUnderstanding[understood_state]}
          tooltipPosition={'right'}
          onClick={() =>
            act('set_language', {
              lang_type: lang_type,
              ...get_understood_button_keys(lang_type, data),
            })
          }
        />
      </Flex.Item>
      <Flex.Item width="33%">
        {partial_understanding_percent(lang_type, data)}
      </Flex.Item>
    </Flex>
  );
};

const LanguagePageInner = (props: {
  base_languages: Language[];
  max_spoken_languages: number;
  max_understood_languages: number;
}) => {
  const { data } = useBackend<Data>();
  const { base_languages, max_spoken_languages, max_understood_languages } =
    props;
  const {
    spoken_languages,
    pref_spoken_languages,
    pref_unspoken_languages,
    understood_languages,
    pref_understood_languages,
    pref_ununderstood_languages,
  } = data;

  const all_spoken_minus_unspoken = spoken_languages
    .concat(pref_spoken_languages)
    .filter((item) => !pref_unspoken_languages.includes(item));
  const all_understood_minus_ununderstood = understood_languages
    .concat(pref_understood_languages)
    .filter((item) => !pref_ununderstood_languages.includes(item));

  return (
    <Flex grow>
      <Flex.Item width="79%" pr="1%">
        <Section
          scrollable
          title={
            <Flex align="center" pr="4%">
              <Flex.Item width="33%"> Language</Flex.Item>
              <Flex.Item grow>
                <Tooltip
                  content="Speaking a language allows you to
                    communicate verbally with others who understand it.
                    It does NOT necessarily mean you can understand the language."
                >
                  <Box
                    inline
                    style={{
                      borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
                    }}
                  >
                    Spoken
                  </Box>
                </Tooltip>
              </Flex.Item>
              <Flex.Item grow>
                <Tooltip
                  content="Understanding a language allows you to
                    comprehend what others are saying in it.
                    It does NOT necessarily mean you can speak the language."
                >
                  <Box
                    inline
                    style={{
                      borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
                    }}
                  >
                    Understood
                  </Box>
                </Tooltip>
              </Flex.Item>
              <Flex.Item width="33%">
                <Tooltip
                  content="Partial understanding indicates what percentage
                    of words in the language you are able to understand,
                    if you otherwise are incapable of fully understanding it."
                >
                  <Box
                    inline
                    style={{
                      borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
                    }}
                  >
                    Partial Understanding
                  </Box>
                </Tooltip>
              </Flex.Item>
            </Flex>
          }
        >
          {base_languages
            .sort((a, b) => (a.name > b.name ? 1 : -1))
            .map((language) => (
              <LanguageRow
                displayed_language={language}
                spoken_cap={max_spoken_languages}
                understood_cap={max_understood_languages}
                key={language.type}
              />
            ))}
        </Section>
      </Flex.Item>
      <Flex.Item width="20%">
        <Section align="center">
          <Stack vertical>
            <Stack.Item>
              <Box fontSize="18px" pb={1}>
                Spoken Languages
              </Box>
              <Box
                bold
                fontSize="20px"
                backgroundColor="white"
                color="black"
                pb={0.5}
              >
                {pref_spoken_languages.length} / {max_spoken_languages}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box fontSize="18px" pb={1}>
                Understood Languages
              </Box>
              <Box
                bold
                fontSize="20px"
                backgroundColor="white"
                color="black"
                pb={0.5}
              >
                {pref_understood_languages.length} / {max_understood_languages}
              </Box>
            </Stack.Item>
            {all_spoken_minus_unspoken.length <= 0 && (
              <Stack.Item>
                <NoticeBox color="red" mt={0.5} preserveWhitespace>
                  {`You can't speak any languages!

You will be completely unable to communicate verbally, even through sign language.

You may want to select at least one language to speak.`}
                </NoticeBox>
              </Stack.Item>
            )}
            {all_understood_minus_ununderstood.length <= 0 && (
              <Stack.Item>
                <NoticeBox color="red" mt={0.5} preserveWhitespace>
                  {`You can't understand any languages!

You won't be able to understand any speech, and translating will be very difficult.

You may want to select at least one language to understand.`}
                </NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

export const LanguagePage = () => {
  const server_data = useServerPrefs();

  return server_data ? (
    <LanguagePageInner
      base_languages={server_data.language.base_languages}
      max_spoken_languages={server_data.language.max_spoken_languages}
      max_understood_languages={server_data.language.max_understood_languages}
    />
  ) : (
    <NoticeBox>Loading...</NoticeBox>
  );
};
