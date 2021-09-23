/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
<<<<<<< HEAD
import { Box, BoxProps, unit } from './Box';

export interface FlexProps extends BoxProps {
=======
import { BoxProps, computeBoxClassName, computeBoxProps, unit } from './Box';

export type FlexProps = BoxProps & {
>>>>>>> remotes/tg/master
  direction?: string | BooleanLike;
  wrap?: string | BooleanLike;
  align?: string | BooleanLike;
  justify?: string | BooleanLike;
  inline?: BooleanLike;
<<<<<<< HEAD
}
=======
};

export const computeFlexClassName = (props: FlexProps) => {
  return classes([
    'Flex',
    props.inline && 'Flex--inline',
    Byond.IS_LTE_IE10 && 'Flex--iefix',
    Byond.IS_LTE_IE10 && props.direction === 'column' && 'Flex--iefix--column',
    computeBoxClassName(props),
  ]);
};
>>>>>>> remotes/tg/master

export const computeFlexProps = (props: FlexProps) => {
  const {
    className,
    direction,
    wrap,
    align,
    justify,
    inline,
    ...rest
  } = props;
<<<<<<< HEAD
  return {
    className: classes([
      'Flex',
      Byond.IS_LTE_IE10 && (
        direction === 'column'
          ? 'Flex--iefix--column'
          : 'Flex--iefix'
      ),
      inline && 'Flex--inline',
      className,
    ]),
=======
  return computeBoxProps({
>>>>>>> remotes/tg/master
    style: {
      ...rest.style,
      'flex-direction': direction,
      'flex-wrap': wrap === true ? 'wrap' : wrap,
      'align-items': align,
      'justify-content': justify,
    },
    ...rest,
<<<<<<< HEAD
  };
};

export const Flex = props => (
  <Box {...computeFlexProps(props)} />
);

Flex.defaultHooks = pureComponentHooks;

export interface FlexItemProps extends BoxProps {
=======
  });
};

export const Flex = props => {
  const { className, ...rest } = props;
  return (
    <div
      className={classes([
        className,
        computeFlexClassName(rest),
      ])}
      {...computeFlexProps(rest)}
    />
  );
};

Flex.defaultHooks = pureComponentHooks;

export type FlexItemProps = BoxProps & {
>>>>>>> remotes/tg/master
  grow?: number;
  order?: number;
  shrink?: number;
  basis?: string | BooleanLike;
  align?: string | BooleanLike;
<<<<<<< HEAD
}
=======
};

export const computeFlexItemClassName = (props: FlexItemProps) => {
  return classes([
    'Flex__item',
    Byond.IS_LTE_IE10 && 'Flex__item--iefix',
    computeBoxClassName(props),
  ]);
};
>>>>>>> remotes/tg/master

export const computeFlexItemProps = (props: FlexItemProps) => {
  const {
    className,
    style,
    grow,
    order,
    shrink,
    // IE11: Always set basis to specified width, which fixes certain
    // bugs when rendering tables inside the flex.
    basis = props.width,
    align,
    ...rest
  } = props;
<<<<<<< HEAD
  return {
    className: classes([
      'Flex__item',
      Byond.IS_LTE_IE10 && 'Flex__item--iefix',
      Byond.IS_LTE_IE10 && (grow && grow > 0) && 'Flex__item--iefix--grow',
      className,
    ]),
=======
  return computeBoxProps({
>>>>>>> remotes/tg/master
    style: {
      ...style,
      'flex-grow': grow !== undefined && Number(grow),
      'flex-shrink': shrink !== undefined && Number(shrink),
      'flex-basis': unit(basis),
      'order': order,
      'align-self': align,
    },
    ...rest,
<<<<<<< HEAD
  };
};

const FlexItem = props => (
  <Box {...computeFlexItemProps(props)} />
);
=======
  });
};

const FlexItem = props => {
  const { className, ...rest } = props;
  return (
    <div
      className={classes([
        className,
        computeFlexItemClassName(props),
      ])}
      {...computeFlexItemProps(rest)}
    />
  );
};
>>>>>>> remotes/tg/master

FlexItem.defaultHooks = pureComponentHooks;

Flex.Item = FlexItem;
