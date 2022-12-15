import { useBackend } from '../backend';
import { Button, Dimmer, Section, Stack } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from 'common/react';

type Data = {
  pref_name: string; // mob name. "john doe"
  species: string; // DM species ID
  selected_lang: string; // language typepath
  trilingual: BooleanLike;
  blacklisted_species: string[]; // list of DM species IDs
  base_languages: Language[];
  bonus_languages: Language[];
};

type Language = {
  name: string;
  type: string; // language typepath
  barred_species: string | null; // DM species ID (or nothing)
  allowed_species: string | null; // DM species ID (or nothing)
};

export const LanguageStack = (
  props: {
    language: Language;
    species: string;
    selected_lang: string;
    tooltip: string;
  },
  context
) => {
  const { act, data } = useBackend<Language>(context);

  const { name, type, barred_species, allowed_species } = props.language;

  return (
    <Stack>
      <Stack.Item grow align="left">
        {name}
      </Stack.Item>
      <Stack.Item>
        <Button.Checkbox
          fluid
          checked={type === props.selected_lang}
          disabled={
            barred_species === props.species ||
            (allowed_species !== props.species && allowed_species)
          }
          tooltip={props.tooltip}
          content="Select"
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

export const _LanguagePicker = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const {
    pref_name,
    species,
    selected_lang,
    trilingual,
    blacklisted_species = [],
    base_languages = [],
    bonus_languages = [],
  } = data;

  return (
    <Window title={pref_name + "'s Languages"} width={385}>
      <Window.Content>
        {!!trilingual && (
          <Dimmer vertical align="center">
            <Stack.Item fontSize="18px">
              You cannot chose a language with the trilingual quirk.
            </Stack.Item>
          </Dimmer>
        )}
        {blacklisted_species.includes(species) && (
          <Dimmer vertical align="center">
            <Stack.Item fontSize="18px">
              Your species already starts cannot learn any additional languages.
            </Stack.Item>
          </Dimmer>
        )}
        <Section title="Base Racial Languages">
          <Stack vertical>
            {base_languages.map((language) => (
              <Stack.Item key={language}>
                <LanguageStack
                  language={language}
                  selected_lang={selected_lang}
                  species={species}
                  tooltip={
                    language.barred_species &&
                    language.barred_species === species
                      ? `This language cannot be selected by
                    the "${language.barred_species}" species.`
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
              <Stack.Item key={language}>
                <LanguageStack
                  language={language}
                  selected_lang={selected_lang}
                  species={species}
                  tooltip={`This language requires the
                    the "${language.allowed_species}" species.`}
                />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
