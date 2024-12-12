import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Flex,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from '../../components';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

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

const StateToColor = {
  [LanguageState.DEFAULT]: 'good',
  [LanguageState.DISABLED]: 'bad',
  [LanguageState.ENABLED]: 'average',
  [LanguageState.NONE]: 'default',
};

const StateToTooltip = {
  [LanguageState.DEFAULT]: 'You know this feature due to your species.',
  [LanguageState.DISABLED]: 'You have disabled this feature of your species.',
  [LanguageState.ENABLED]: 'You have enabled this feature.',
  [LanguageState.NONE]: '',
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
        <Button
          tooltip={displayed_language.desc}
          disabled={!displayed_language.desc}
          icon="question-circle"
          mr={1}
        />
        {displayed_language.name}
      </Flex.Item>
      <Flex.Item grow>
        <Button
          disabled={
            !displayed_language.unlocked ||
            (pref_spoken_languages.length >= spoken_cap && !ignore_spoken_cap)
          }
          icon={StateToIcon[spoken_state]}
          color={StateToColor[spoken_state]}
          tooltip={StateToTooltip[spoken_state]}
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
          color={StateToColor[understood_state]}
          tooltip={StateToTooltip[understood_state]}
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
      <Flex.Item width="79%" mr={'1%'}>
        <Section
          scrollable
          title={
            <Flex align="center">
              <Flex.Item width="33%">Language</Flex.Item>
              <Flex.Item grow>Spoken</Flex.Item>
              <Flex.Item grow>Understood</Flex.Item>
              <Flex.Item width="33%">
                Partial Understanding
                <Button
                  icon="info"
                  tooltip="What percentage of words you are able to understand,
                    despite not ultimately knowing the language."
                  ml={1}
                />
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
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        return serverData ? (
          <LanguagePageInner
            base_languages={serverData.language.base_languages}
            max_spoken_languages={serverData.language.max_spoken_languages}
            max_understood_languages={
              serverData.language.max_understood_languages
            }
          />
        ) : (
          <NoticeBox>Loading...</NoticeBox>
        );
      }}
    />
  );
};
