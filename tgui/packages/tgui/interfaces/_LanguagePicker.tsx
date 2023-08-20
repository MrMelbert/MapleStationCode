import { useBackend } from '../backend';
import { Button, Dimmer, Section, Stack } from '../components';
import { BooleanLike } from 'common/react';

type typePath = string;

type Data = {
  pref_name: string; // mob name. "john doe"
  species: typePath; // species typepath
  selected_lang: typePath | string; // language typepath
  trilingual: BooleanLike;
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

export const LanguageStack = (
  props: {
    language: Language;
    selected_lang: typePath;
    tooltip: string;
  },
  context
) => {
  const { act } = useBackend<Language>(context);
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

const WarningDimmer = (props, context) => {
  return (
    <Dimmer vertical align="center">
      <Stack.Item fontSize="18px">{props.message}</Stack.Item>
    </Dimmer>
  );
};

export const LanguagePage = (props, context) => {
  const { data } = useBackend<Data>(context);

  const {
    species,
    selected_lang,
    trilingual,
    blacklisted_species = [],
    base_languages = [],
    bonus_languages = [],
  } = data;

  return (
    <>
      {!!trilingual && (
        <WarningDimmer
          message={'You cannot chose a language with the trilingual quirk.'}
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
    </>
  );
};
