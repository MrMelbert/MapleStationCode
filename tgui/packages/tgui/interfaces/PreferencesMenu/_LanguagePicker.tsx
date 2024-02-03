import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  NoticeBox,
  Section,
  Stack,
} from '../../components';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

type typePath = string;

type Data = {
  pref_name: string;
  selected_species: typePath;
  selected_lang: typePath | string;
  trilingual: BooleanLike;
  bilingual: BooleanLike;
};

type Species = {
  name: string;
  type: typePath;
};

export type Language = {
  name: string;
  type: typePath;
  incompatible_with: Species | null;
  requires: Species | null;
};

// Fake an ispath() check to determine if this species can learn this language
const isPickable = (lang: Language, species: typePath): boolean => {
  if (lang.incompatible_with && species.includes(lang.incompatible_with.type)) {
    return false;
  }
  if (lang.requires && !species.includes(lang.requires.type)) {
    return false;
  }
  return true;
};

const getLanguageTooltip = (lang: Language): string => {
  if (lang.incompatible_with && lang.requires) {
    return `This language cannot be selected by
      the "${lang.incompatible_with.name}" species and requires
      the "${lang.requires.name}" species.`;
  }
  if (lang.incompatible_with) {
    return `This language cannot be selected by
      the "${lang.incompatible_with.name}" species.`;
  }
  if (lang.requires) {
    return `This language requires
      the "${lang.requires.name}" species.`;
  }
  return '';
};

const LanguageStack = (props: {
  language: Language;
  selected_lang: typePath;
  selected_species: typePath;
}) => {
  const { act } = useBackend<Language>();
  const { language, selected_species } = props;
  const { name, type } = language;
  const pickable = isPickable(language, selected_species);

  return (
    <Stack>
      <Stack.Item grow align="left">
        {name}
      </Stack.Item>
      <Stack.Item>
        <Button.Checkbox
          fluid
          checked={type === props.selected_lang}
          disabled={!pickable}
          tooltip={pickable ? '' : getLanguageTooltip(language)}
          content={pickable ? 'Select' : 'Locked'}
          onClick={() =>
            act('set_language', {
              lang_type: type,
              deselecting: type === props.selected_lang,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const WarningDimmer = (props) => {
  return (
    <Dimmer align="center">
      <Box fontSize="18px">{props.message}</Box>
    </Dimmer>
  );
};

const LanguagePageInner = (props: {
  base_languages: Language[];
  bonus_languages: Language[];
  blacklisted_species: typePath[];
}) => {
  const { data } = useBackend<Data>();
  const { base_languages, bonus_languages, blacklisted_species } = props;
  const { selected_species, selected_lang, trilingual, bilingual } = data;

  return (
    <Section>
      {!!trilingual && (
        <WarningDimmer
          message={
            'The Trilingual quirk grants you an additional random \
            language - but you cannot select one while the quirk is active.'
          }
        />
      )}
      {!!bilingual && (
        <WarningDimmer
          message={
            'You have the Bilingual quirk selected, so use its \
            selection dropdown instead.'
          }
        />
      )}
      {blacklisted_species.includes(selected_species) && (
        <WarningDimmer
          message={'Your species cannot learn any additional languages.'}
        />
      )}
      <Section title="Base Racial Languages">
        <Stack vertical>
          {base_languages.map((language) => (
            <Stack.Item key={language.name}>
              <LanguageStack
                language={language}
                selected_lang={selected_lang}
                selected_species={selected_species}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Section>
      <Section title="Unique Racial Languages">
        <Stack vertical>
          {bonus_languages.map((language) => (
            <Stack.Item key={language.name}>
              <LanguageStack
                language={language}
                selected_lang={selected_lang}
                selected_species={selected_species}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Section>
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
            bonus_languages={serverData.language.bonus_languages}
            blacklisted_species={serverData.language.blacklisted_species}
          />
        ) : (
          <NoticeBox>Loading...</NoticeBox>
        );
      }}
    />
  );
};
