import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import { Button, Flex, NoticeBox, Section } from '../../components';
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

const LanguageRow = (props: { displayed_language: Language }) => {
  const { act, data } = useBackend<Data>();
  const { displayed_language } = props;

  const lang_type = displayed_language.type;

  const spoken_state = get_spoken_language_state(lang_type, data);
  const understood_state = get_understood_language_state(lang_type, data);

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
          disabled={!displayed_language.unlocked}
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
          disabled={!displayed_language.unlocked}
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
      <Flex.Item width="25%">
        {data.partial_languages[lang_type]}
        {data.partial_languages[lang_type] && '%'}
      </Flex.Item>
    </Flex>
  );
};

const LanguagePageInner = (props: { base_languages: Language[] }) => {
  return (
    <Section
      title={
        <Flex align="center">
          <Flex.Item width="33%">Language</Flex.Item>
          <Flex.Item grow>Spoken</Flex.Item>
          <Flex.Item grow>Understood</Flex.Item>
          <Flex.Item width="25%">
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
      {props.base_languages
        .sort((a, b) => (a.name > b.name ? 1 : -1))
        .map((language) => (
          <LanguageRow displayed_language={language} key={language.type} />
        ))}
    </Section>
  );
};

export const LanguagePage = () => {
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        return serverData ? (
          <LanguagePageInner
            base_languages={serverData.language.base_languages}
          />
        ) : (
          <NoticeBox>Loading...</NoticeBox>
        );
      }}
    />
  );
};
