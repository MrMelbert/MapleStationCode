/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
<<<<<<< HEAD
import { Flex, FlexItemProps, FlexProps } from './Flex';

interface StackProps extends FlexProps {
  vertical?: boolean;
  fill?: boolean;
}
=======
import { RefObject } from 'inferno';
import { computeFlexClassName, computeFlexItemClassName, computeFlexItemProps, computeFlexProps, FlexItemProps, FlexProps } from './Flex';

type StackProps = FlexProps & {
  vertical?: boolean;
  fill?: boolean;
};
>>>>>>> remotes/tg/master

export const Stack = (props: StackProps) => {
  const { className, vertical, fill, ...rest } = props;
  return (
<<<<<<< HEAD
    <Flex
=======
    <div
>>>>>>> remotes/tg/master
      className={classes([
        'Stack',
        fill && 'Stack--fill',
        vertical
          ? 'Stack--vertical'
          : 'Stack--horizontal',
        className,
<<<<<<< HEAD
      ])}
      direction={vertical ? 'column' : 'row'}
      {...rest} />
  );
};

const StackItem = (props: FlexProps) => {
  const { className, ...rest } = props;
  return (
    <Flex.Item
      className={classes([
        'Stack__item',
        className,
      ])}
      {...rest} />
=======
        computeFlexClassName(props),
      ])}
      {...computeFlexProps({
        direction: vertical ? 'column' : 'row',
        ...rest,
      })}
    />
  );
};

type StackItemProps = FlexProps & {
  innerRef?: RefObject<HTMLDivElement>,
};

const StackItem = (props: StackItemProps) => {
  const { className, innerRef, ...rest } = props;
  return (
    <div
      className={classes([
        'Stack__item',
        className,
        computeFlexItemClassName(rest),
      ])}
      ref={innerRef}
      {...computeFlexItemProps(rest)}
    />
>>>>>>> remotes/tg/master
  );
};

Stack.Item = StackItem;

<<<<<<< HEAD
interface StackDividerProps extends FlexItemProps {
  hidden?: boolean;
}
=======
type StackDividerProps = FlexItemProps & {
  hidden?: boolean;
};
>>>>>>> remotes/tg/master

const StackDivider = (props: StackDividerProps) => {
  const { className, hidden, ...rest } = props;
  return (
<<<<<<< HEAD
    <Flex.Item
=======
    <div
>>>>>>> remotes/tg/master
      className={classes([
        'Stack__item',
        'Stack__divider',
        hidden && 'Stack__divider--hidden',
        className,
<<<<<<< HEAD
      ])}
      {...rest} />
=======
        computeFlexItemClassName(rest),
      ])}
      {...computeFlexItemProps(rest)}
    />
>>>>>>> remotes/tg/master
  );
};

Stack.Divider = StackDivider;
