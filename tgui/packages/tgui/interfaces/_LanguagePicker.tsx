import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Dimmer, Section, Stack } from '../components';

type typePath = string;

type Data = {
  pref_name: string; // mob name. "john doe"
  species: typePath; // species typepath
  selected_lang: typePath | string; // language typepath
  trilingual: BooleanLike;
  bilingual: BooleanLike;
  blacklisted_species: typePath[]; // list of species typePaths
  base_languages: Language[];
  bonus_languages: Language[];
};

type Language = {
  name: string;
  type: typePath; // language typepath
  pickable: BooleanLike;
  incompatible_with: string | null;
  requires: string | null;
};

export const LanguageStack = (props: {
  language: Language;
  selected_lang: typePath;
  tooltip: string;
}) => {
  const { act } = useBackend<Language>();
  const { name, type, pickable } = props.language;

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
          tooltip={props.tooltip}
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

export const LanguagePage = () => {
  const { data } = useBackend<Data>();

  const {
    species,
    selected_lang,
    trilingual,
    bilingual,
    blacklisted_species = [],
    base_languages = [],
    bonus_languages = [],
  } = data;

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
      {blacklisted_species.includes(species) && (
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
                tooltip={
                  language.incompatible_with
                    ? `This language cannot be selected by
                    the "${language.incompatible_with}" species.`
                    : ''
                }
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
                tooltip={
                  language.requires
                    ? `This language requires the
                    the "${language.requires}" species.`
                    : ''
                }
              />
            </Stack.Item>
          ))}
        </Stack>
      </Section>
    </Section>
  );
};
