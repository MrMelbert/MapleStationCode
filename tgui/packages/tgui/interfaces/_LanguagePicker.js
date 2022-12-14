import { useBackend } from '../backend';
import { Button, Dimmer, Section, Stack } from '../components';
import { Window } from '../layouts';

export const _LanguagePicker = (props, context) => {
  const { act, data } = useBackend(context);

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
    <Window title={pref_name + "'s Languages"} width={350} height={300}>
      <Window.Content>
        {!!trilingual && (
          <Dimmer>
            You cannot chose a language with the trilingual quirk.
          </Dimmer>
        )}
        {blacklisted_species.includes(species) && (
          <Dimmer>
            Your species already starts with a multitude of languages.
          </Dimmer>
        )}
        <Section title="Base Racial Languages">
          <Stack vertical>
            {base_languages.map((language) => (
              <Stack.Item key={language}>
                <Stack>
                  <Stack.Item grow align="left">
                    {language.name}
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Checkbox
                      fluid
                      checked={language.type === selected_lang}
                      disabled={language.barred_species === species}
                      tooltip={
                        'This language cannot be picked by the ' +
                        language.barred_species +
                        ' species.'
                      }
                      content="Select"
                      onClick={() =>
                        act('set_language', {
                          langType: language.type,
                          deselecting: language.type === selected_lang,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
        <Section title="Unique Racial Languages">
          <Stack vertical>
            {bonus_languages.map((language) => (
              <Stack.Item key={language}>
                <Stack>
                  <Stack.Item grow align="left">
                    {language.name}
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Checkbox
                      fluid
                      checked={language.type === selected_lang}
                      disabled={language.allowed_species !== species}
                      tooltip={
                        'This language requires the ' +
                        language.allowed_species +
                        ' species.'
                      }
                      content="Select"
                      onClick={() =>
                        act('set_language', {
                          langType: language.type,
                          deselecting: language.type === selected_lang,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
