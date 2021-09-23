import { multiline } from "common/string";
import { CheckboxInput, FeatureToggle } from "../base";

export const toggle_speech: FeatureToggle = {
  name: "Toggle Speech Sounds",
  category: "SOUND",
  description: multiline`
    When toggled, you will no longer hear speech sounds.
  `,
  component: CheckboxInput,
};
