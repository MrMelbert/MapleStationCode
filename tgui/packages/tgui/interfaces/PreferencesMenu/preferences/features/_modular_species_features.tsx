import { CheckboxInput, FeatureChoiced, FeatureDropdownInput, FeatureToggle } from "./base";

export const feature_head_tentacles: FeatureChoiced = {
  name: "Head Tentacles",
  component: FeatureDropdownInput,
};

export const hair_lizard: FeatureToggle = {
  name: "Hair Lizard",
  component: CheckboxInput,
};

export const reploid_limbs: FeatureChoiced = {
  name: "Limb Type",
  component: FeatureDropdownInput,
};

export const reploid_ipc_screen: FeatureChoiced = {
  name: "IPC Screen",
  component: FeatureDropdownInput,
};

export const reploid_antenna: FeatureChoiced = {
  name: "Antenna",
  component: FeatureDropdownInput,
};

export const reploid_skintones: FeatureToggle = {
  name: "Use Skintones",
  component: CheckboxInput,
};

export const reploid_ipc_limbs: FeatureChoiced = {
  name: "IPC Chassis Manufacturer",
  component: FeatureDropdownInput,
};
