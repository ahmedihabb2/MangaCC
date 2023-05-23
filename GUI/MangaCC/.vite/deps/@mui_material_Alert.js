import {
  ButtonBase_default,
  alpha,
  capitalize_default,
  chainPropTypes,
  clsx_m_default,
  composeClasses,
  darken,
  defaultTheme_default,
  generateUtilityClass,
  generateUtilityClasses,
  identifier_default,
  integerPropType_default,
  lighten,
  require_jsx_runtime,
  require_prop_types,
  styled_default,
  useThemeProps,
  useTheme_default
} from "./chunk-KHGVSD6V.js";
import "./chunk-RVSLBP3T.js";
import {
  require_react
} from "./chunk-ST3U5LCA.js";
import {
  __toESM
} from "./chunk-DFKQJ226.js";

// node_modules/@mui/material/Alert/Alert.js
var React11 = __toESM(require_react());
var import_prop_types4 = __toESM(require_prop_types());

// node_modules/@mui/material/Paper/Paper.js
var React2 = __toESM(require_react());
var import_prop_types = __toESM(require_prop_types());

// node_modules/@mui/material/styles/getOverlayAlpha.js
var getOverlayAlpha = (elevation) => {
  let alphaValue;
  if (elevation < 1) {
    alphaValue = 5.11916 * elevation ** 2;
  } else {
    alphaValue = 4.5 * Math.log(elevation + 1) + 2;
  }
  return (alphaValue / 100).toFixed(2);
};
var getOverlayAlpha_default = getOverlayAlpha;

// node_modules/@mui/material/styles/useTheme.js
var React = __toESM(require_react());
function useTheme() {
  const theme = useTheme_default(defaultTheme_default);
  if (true) {
    React.useDebugValue(theme);
  }
  return theme[identifier_default] || theme;
}

// node_modules/@mui/material/Paper/paperClasses.js
function getPaperUtilityClass(slot) {
  return generateUtilityClass("MuiPaper", slot);
}
var paperClasses = generateUtilityClasses("MuiPaper", ["root", "rounded", "outlined", "elevation", "elevation0", "elevation1", "elevation2", "elevation3", "elevation4", "elevation5", "elevation6", "elevation7", "elevation8", "elevation9", "elevation10", "elevation11", "elevation12", "elevation13", "elevation14", "elevation15", "elevation16", "elevation17", "elevation18", "elevation19", "elevation20", "elevation21", "elevation22", "elevation23", "elevation24"]);

// node_modules/@mui/material/Paper/Paper.js
var import_jsx_runtime = __toESM(require_jsx_runtime());
var useUtilityClasses = (ownerState) => {
  const {
    square,
    elevation,
    variant,
    classes
  } = ownerState;
  const slots = {
    root: ["root", variant, !square && "rounded", variant === "elevation" && `elevation${elevation}`]
  };
  return composeClasses(slots, getPaperUtilityClass, classes);
};
var PaperRoot = styled_default("div", {
  name: "MuiPaper",
  slot: "Root",
  overridesResolver: (props, styles) => {
    const {
      ownerState
    } = props;
    return [styles.root, styles[ownerState.variant], !ownerState.square && styles.rounded, ownerState.variant === "elevation" && styles[`elevation${ownerState.elevation}`]];
  }
})(({
  theme,
  ownerState
}) => {
  var _theme$vars$overlays;
  return {
    backgroundColor: (theme.vars || theme).palette.background.paper,
    color: (theme.vars || theme).palette.text.primary,
    transition: theme.transitions.create("box-shadow"),
    ...!ownerState.square && {
      borderRadius: theme.shape.borderRadius
    },
    ...ownerState.variant === "outlined" && {
      border: `1px solid ${(theme.vars || theme).palette.divider}`
    },
    ...ownerState.variant === "elevation" && {
      boxShadow: (theme.vars || theme).shadows[ownerState.elevation],
      ...!theme.vars && theme.palette.mode === "dark" && {
        backgroundImage: `linear-gradient(${alpha("#fff", getOverlayAlpha_default(ownerState.elevation))}, ${alpha("#fff", getOverlayAlpha_default(ownerState.elevation))})`
      },
      ...theme.vars && {
        backgroundImage: (_theme$vars$overlays = theme.vars.overlays) == null ? void 0 : _theme$vars$overlays[ownerState.elevation]
      }
    }
  };
});
var Paper = React2.forwardRef(function Paper2(inProps, ref) {
  const props = useThemeProps({
    props: inProps,
    name: "MuiPaper"
  });
  const {
    className,
    component = "div",
    elevation = 1,
    square = false,
    variant = "elevation",
    ...other
  } = props;
  const ownerState = {
    ...props,
    component,
    elevation,
    square,
    variant
  };
  const classes = useUtilityClasses(ownerState);
  if (true) {
    const theme = useTheme();
    if (theme.shadows[elevation] === void 0) {
      console.error([`MUI: The elevation provided <Paper elevation={${elevation}}> is not available in the theme.`, `Please make sure that \`theme.shadows[${elevation}]\` is defined.`].join("\n"));
    }
  }
  return (0, import_jsx_runtime.jsx)(PaperRoot, {
    as: component,
    ownerState,
    className: clsx_m_default(classes.root, className),
    ref,
    ...other
  });
});
true ? Paper.propTypes = {
  // ----------------------------- Warning --------------------------------
  // | These PropTypes are generated from the TypeScript type definitions |
  // |     To update them edit the d.ts file and run "yarn proptypes"     |
  // ----------------------------------------------------------------------
  /**
   * The content of the component.
   */
  children: import_prop_types.default.node,
  /**
   * Override or extend the styles applied to the component.
   */
  classes: import_prop_types.default.object,
  /**
   * @ignore
   */
  className: import_prop_types.default.string,
  /**
   * The component used for the root node.
   * Either a string to use a HTML element or a component.
   */
  component: import_prop_types.default.elementType,
  /**
   * Shadow depth, corresponds to `dp` in the spec.
   * It accepts values between 0 and 24 inclusive.
   * @default 1
   */
  elevation: chainPropTypes(integerPropType_default, (props) => {
    const {
      elevation,
      variant
    } = props;
    if (elevation > 0 && variant === "outlined") {
      return new Error(`MUI: Combining \`elevation={${elevation}}\` with \`variant="${variant}"\` has no effect. Either use \`elevation={0}\` or use a different \`variant\`.`);
    }
    return null;
  }),
  /**
   * If `true`, rounded corners are disabled.
   * @default false
   */
  square: import_prop_types.default.bool,
  /**
   * The system prop that allows defining system overrides as well as additional CSS styles.
   */
  sx: import_prop_types.default.oneOfType([import_prop_types.default.arrayOf(import_prop_types.default.oneOfType([import_prop_types.default.func, import_prop_types.default.object, import_prop_types.default.bool])), import_prop_types.default.func, import_prop_types.default.object]),
  /**
   * The variant to use.
   * @default 'elevation'
   */
  variant: import_prop_types.default.oneOfType([import_prop_types.default.oneOf(["elevation", "outlined"]), import_prop_types.default.string])
} : void 0;
var Paper_default = Paper;

// node_modules/@mui/material/Alert/alertClasses.js
function getAlertUtilityClass(slot) {
  return generateUtilityClass("MuiAlert", slot);
}
var alertClasses = generateUtilityClasses("MuiAlert", ["root", "action", "icon", "message", "filled", "filledSuccess", "filledInfo", "filledWarning", "filledError", "outlined", "outlinedSuccess", "outlinedInfo", "outlinedWarning", "outlinedError", "standard", "standardSuccess", "standardInfo", "standardWarning", "standardError"]);
var alertClasses_default = alertClasses;

// node_modules/@mui/material/IconButton/IconButton.js
var React3 = __toESM(require_react());
var import_prop_types2 = __toESM(require_prop_types());

// node_modules/@mui/material/IconButton/iconButtonClasses.js
function getIconButtonUtilityClass(slot) {
  return generateUtilityClass("MuiIconButton", slot);
}
var iconButtonClasses = generateUtilityClasses("MuiIconButton", ["root", "disabled", "colorInherit", "colorPrimary", "colorSecondary", "colorError", "colorInfo", "colorSuccess", "colorWarning", "edgeStart", "edgeEnd", "sizeSmall", "sizeMedium", "sizeLarge"]);
var iconButtonClasses_default = iconButtonClasses;

// node_modules/@mui/material/IconButton/IconButton.js
var import_jsx_runtime2 = __toESM(require_jsx_runtime());
var useUtilityClasses2 = (ownerState) => {
  const {
    classes,
    disabled,
    color,
    edge,
    size
  } = ownerState;
  const slots = {
    root: ["root", disabled && "disabled", color !== "default" && `color${capitalize_default(color)}`, edge && `edge${capitalize_default(edge)}`, `size${capitalize_default(size)}`]
  };
  return composeClasses(slots, getIconButtonUtilityClass, classes);
};
var IconButtonRoot = styled_default(ButtonBase_default, {
  name: "MuiIconButton",
  slot: "Root",
  overridesResolver: (props, styles) => {
    const {
      ownerState
    } = props;
    return [styles.root, ownerState.color !== "default" && styles[`color${capitalize_default(ownerState.color)}`], ownerState.edge && styles[`edge${capitalize_default(ownerState.edge)}`], styles[`size${capitalize_default(ownerState.size)}`]];
  }
})(({
  theme,
  ownerState
}) => ({
  textAlign: "center",
  flex: "0 0 auto",
  fontSize: theme.typography.pxToRem(24),
  padding: 8,
  borderRadius: "50%",
  overflow: "visible",
  // Explicitly set the default value to solve a bug on IE11.
  color: (theme.vars || theme).palette.action.active,
  transition: theme.transitions.create("background-color", {
    duration: theme.transitions.duration.shortest
  }),
  ...!ownerState.disableRipple && {
    "&:hover": {
      backgroundColor: theme.vars ? `rgba(${theme.vars.palette.action.activeChannel} / ${theme.vars.palette.action.hoverOpacity})` : alpha(theme.palette.action.active, theme.palette.action.hoverOpacity),
      // Reset on touch devices, it doesn't add specificity
      "@media (hover: none)": {
        backgroundColor: "transparent"
      }
    }
  },
  ...ownerState.edge === "start" && {
    marginLeft: ownerState.size === "small" ? -3 : -12
  },
  ...ownerState.edge === "end" && {
    marginRight: ownerState.size === "small" ? -3 : -12
  }
}), ({
  theme,
  ownerState
}) => {
  var _palette;
  const palette = (_palette = (theme.vars || theme).palette) == null ? void 0 : _palette[ownerState.color];
  return {
    ...ownerState.color === "inherit" && {
      color: "inherit"
    },
    ...ownerState.color !== "inherit" && ownerState.color !== "default" && {
      color: palette == null ? void 0 : palette.main,
      ...!ownerState.disableRipple && {
        "&:hover": {
          ...palette && {
            backgroundColor: theme.vars ? `rgba(${palette.mainChannel} / ${theme.vars.palette.action.hoverOpacity})` : alpha(palette.main, theme.palette.action.hoverOpacity)
          },
          // Reset on touch devices, it doesn't add specificity
          "@media (hover: none)": {
            backgroundColor: "transparent"
          }
        }
      }
    },
    ...ownerState.size === "small" && {
      padding: 5,
      fontSize: theme.typography.pxToRem(18)
    },
    ...ownerState.size === "large" && {
      padding: 12,
      fontSize: theme.typography.pxToRem(28)
    },
    [`&.${iconButtonClasses_default.disabled}`]: {
      backgroundColor: "transparent",
      color: (theme.vars || theme).palette.action.disabled
    }
  };
});
var IconButton = React3.forwardRef(function IconButton2(inProps, ref) {
  const props = useThemeProps({
    props: inProps,
    name: "MuiIconButton"
  });
  const {
    edge = false,
    children,
    className,
    color = "default",
    disabled = false,
    disableFocusRipple = false,
    size = "medium",
    ...other
  } = props;
  const ownerState = {
    ...props,
    edge,
    color,
    disabled,
    disableFocusRipple,
    size
  };
  const classes = useUtilityClasses2(ownerState);
  return (0, import_jsx_runtime2.jsx)(IconButtonRoot, {
    className: clsx_m_default(classes.root, className),
    centerRipple: true,
    focusRipple: !disableFocusRipple,
    disabled,
    ref,
    ownerState,
    ...other,
    children
  });
});
true ? IconButton.propTypes = {
  // ----------------------------- Warning --------------------------------
  // | These PropTypes are generated from the TypeScript type definitions |
  // |     To update them edit the d.ts file and run "yarn proptypes"     |
  // ----------------------------------------------------------------------
  /**
   * The icon to display.
   */
  children: chainPropTypes(import_prop_types2.default.node, (props) => {
    const found = React3.Children.toArray(props.children).some((child) => React3.isValidElement(child) && child.props.onClick);
    if (found) {
      return new Error(["MUI: You are providing an onClick event listener to a child of a button element.", "Prefer applying it to the IconButton directly.", "This guarantees that the whole <button> will be responsive to click events."].join("\n"));
    }
    return null;
  }),
  /**
   * Override or extend the styles applied to the component.
   */
  classes: import_prop_types2.default.object,
  /**
   * @ignore
   */
  className: import_prop_types2.default.string,
  /**
   * The color of the component.
   * It supports both default and custom theme colors, which can be added as shown in the
   * [palette customization guide](https://mui.com/material-ui/customization/palette/#adding-new-colors).
   * @default 'default'
   */
  color: import_prop_types2.default.oneOfType([import_prop_types2.default.oneOf(["inherit", "default", "primary", "secondary", "error", "info", "success", "warning"]), import_prop_types2.default.string]),
  /**
   * If `true`, the component is disabled.
   * @default false
   */
  disabled: import_prop_types2.default.bool,
  /**
   * If `true`, the  keyboard focus ripple is disabled.
   * @default false
   */
  disableFocusRipple: import_prop_types2.default.bool,
  /**
   * If `true`, the ripple effect is disabled.
   *
   * ⚠️ Without a ripple there is no styling for :focus-visible by default. Be sure
   * to highlight the element by applying separate styles with the `.Mui-focusVisible` class.
   * @default false
   */
  disableRipple: import_prop_types2.default.bool,
  /**
   * If given, uses a negative margin to counteract the padding on one
   * side (this is often helpful for aligning the left or right
   * side of the icon with content above or below, without ruining the border
   * size and shape).
   * @default false
   */
  edge: import_prop_types2.default.oneOf(["end", "start", false]),
  /**
   * The size of the component.
   * `small` is equivalent to the dense button styling.
   * @default 'medium'
   */
  size: import_prop_types2.default.oneOfType([import_prop_types2.default.oneOf(["small", "medium", "large"]), import_prop_types2.default.string]),
  /**
   * The system prop that allows defining system overrides as well as additional CSS styles.
   */
  sx: import_prop_types2.default.oneOfType([import_prop_types2.default.arrayOf(import_prop_types2.default.oneOfType([import_prop_types2.default.func, import_prop_types2.default.object, import_prop_types2.default.bool])), import_prop_types2.default.func, import_prop_types2.default.object])
} : void 0;
var IconButton_default = IconButton;

// node_modules/@mui/material/internal/svg-icons/SuccessOutlined.js
var React6 = __toESM(require_react());

// node_modules/@mui/material/utils/createSvgIcon.js
var React5 = __toESM(require_react());

// node_modules/@mui/material/SvgIcon/SvgIcon.js
var React4 = __toESM(require_react());
var import_prop_types3 = __toESM(require_prop_types());

// node_modules/@mui/material/SvgIcon/svgIconClasses.js
function getSvgIconUtilityClass(slot) {
  return generateUtilityClass("MuiSvgIcon", slot);
}
var svgIconClasses = generateUtilityClasses("MuiSvgIcon", ["root", "colorPrimary", "colorSecondary", "colorAction", "colorError", "colorDisabled", "fontSizeInherit", "fontSizeSmall", "fontSizeMedium", "fontSizeLarge"]);

// node_modules/@mui/material/SvgIcon/SvgIcon.js
var import_jsx_runtime3 = __toESM(require_jsx_runtime());
var import_jsx_runtime4 = __toESM(require_jsx_runtime());
var useUtilityClasses3 = (ownerState) => {
  const {
    color,
    fontSize,
    classes
  } = ownerState;
  const slots = {
    root: ["root", color !== "inherit" && `color${capitalize_default(color)}`, `fontSize${capitalize_default(fontSize)}`]
  };
  return composeClasses(slots, getSvgIconUtilityClass, classes);
};
var SvgIconRoot = styled_default("svg", {
  name: "MuiSvgIcon",
  slot: "Root",
  overridesResolver: (props, styles) => {
    const {
      ownerState
    } = props;
    return [styles.root, ownerState.color !== "inherit" && styles[`color${capitalize_default(ownerState.color)}`], styles[`fontSize${capitalize_default(ownerState.fontSize)}`]];
  }
})(({
  theme,
  ownerState
}) => {
  var _theme$transitions, _theme$transitions$cr, _theme$transitions2, _theme$transitions2$d, _theme$typography, _theme$typography$pxT, _theme$typography2, _theme$typography2$px, _theme$typography3, _theme$typography3$px, _palette$ownerState$c, _palette, _palette$ownerState$c2, _palette2, _palette2$action, _palette3, _palette3$action;
  return {
    userSelect: "none",
    width: "1em",
    height: "1em",
    display: "inline-block",
    fill: "currentColor",
    flexShrink: 0,
    transition: (_theme$transitions = theme.transitions) == null ? void 0 : (_theme$transitions$cr = _theme$transitions.create) == null ? void 0 : _theme$transitions$cr.call(_theme$transitions, "fill", {
      duration: (_theme$transitions2 = theme.transitions) == null ? void 0 : (_theme$transitions2$d = _theme$transitions2.duration) == null ? void 0 : _theme$transitions2$d.shorter
    }),
    fontSize: {
      inherit: "inherit",
      small: ((_theme$typography = theme.typography) == null ? void 0 : (_theme$typography$pxT = _theme$typography.pxToRem) == null ? void 0 : _theme$typography$pxT.call(_theme$typography, 20)) || "1.25rem",
      medium: ((_theme$typography2 = theme.typography) == null ? void 0 : (_theme$typography2$px = _theme$typography2.pxToRem) == null ? void 0 : _theme$typography2$px.call(_theme$typography2, 24)) || "1.5rem",
      large: ((_theme$typography3 = theme.typography) == null ? void 0 : (_theme$typography3$px = _theme$typography3.pxToRem) == null ? void 0 : _theme$typography3$px.call(_theme$typography3, 35)) || "2.1875rem"
    }[ownerState.fontSize],
    // TODO v5 deprecate, v6 remove for sx
    color: (_palette$ownerState$c = (_palette = (theme.vars || theme).palette) == null ? void 0 : (_palette$ownerState$c2 = _palette[ownerState.color]) == null ? void 0 : _palette$ownerState$c2.main) != null ? _palette$ownerState$c : {
      action: (_palette2 = (theme.vars || theme).palette) == null ? void 0 : (_palette2$action = _palette2.action) == null ? void 0 : _palette2$action.active,
      disabled: (_palette3 = (theme.vars || theme).palette) == null ? void 0 : (_palette3$action = _palette3.action) == null ? void 0 : _palette3$action.disabled,
      inherit: void 0
    }[ownerState.color]
  };
});
var SvgIcon = React4.forwardRef(function SvgIcon2(inProps, ref) {
  const props = useThemeProps({
    props: inProps,
    name: "MuiSvgIcon"
  });
  const {
    children,
    className,
    color = "inherit",
    component = "svg",
    fontSize = "medium",
    htmlColor,
    inheritViewBox = false,
    titleAccess,
    viewBox = "0 0 24 24",
    ...other
  } = props;
  const ownerState = {
    ...props,
    color,
    component,
    fontSize,
    instanceFontSize: inProps.fontSize,
    inheritViewBox,
    viewBox
  };
  const more = {};
  if (!inheritViewBox) {
    more.viewBox = viewBox;
  }
  const classes = useUtilityClasses3(ownerState);
  return (0, import_jsx_runtime4.jsxs)(SvgIconRoot, {
    as: component,
    className: clsx_m_default(classes.root, className),
    focusable: "false",
    color: htmlColor,
    "aria-hidden": titleAccess ? void 0 : true,
    role: titleAccess ? "img" : void 0,
    ref,
    ...more,
    ...other,
    ownerState,
    children: [children, titleAccess ? (0, import_jsx_runtime3.jsx)("title", {
      children: titleAccess
    }) : null]
  });
});
true ? SvgIcon.propTypes = {
  // ----------------------------- Warning --------------------------------
  // | These PropTypes are generated from the TypeScript type definitions |
  // |     To update them edit the d.ts file and run "yarn proptypes"     |
  // ----------------------------------------------------------------------
  /**
   * Node passed into the SVG element.
   */
  children: import_prop_types3.default.node,
  /**
   * Override or extend the styles applied to the component.
   */
  classes: import_prop_types3.default.object,
  /**
   * @ignore
   */
  className: import_prop_types3.default.string,
  /**
   * The color of the component.
   * It supports both default and custom theme colors, which can be added as shown in the
   * [palette customization guide](https://mui.com/material-ui/customization/palette/#adding-new-colors).
   * You can use the `htmlColor` prop to apply a color attribute to the SVG element.
   * @default 'inherit'
   */
  color: import_prop_types3.default.oneOfType([import_prop_types3.default.oneOf(["inherit", "action", "disabled", "primary", "secondary", "error", "info", "success", "warning"]), import_prop_types3.default.string]),
  /**
   * The component used for the root node.
   * Either a string to use a HTML element or a component.
   */
  component: import_prop_types3.default.elementType,
  /**
   * The fontSize applied to the icon. Defaults to 24px, but can be configure to inherit font size.
   * @default 'medium'
   */
  fontSize: import_prop_types3.default.oneOfType([import_prop_types3.default.oneOf(["inherit", "large", "medium", "small"]), import_prop_types3.default.string]),
  /**
   * Applies a color attribute to the SVG element.
   */
  htmlColor: import_prop_types3.default.string,
  /**
   * If `true`, the root node will inherit the custom `component`'s viewBox and the `viewBox`
   * prop will be ignored.
   * Useful when you want to reference a custom `component` and have `SvgIcon` pass that
   * `component`'s viewBox to the root node.
   * @default false
   */
  inheritViewBox: import_prop_types3.default.bool,
  /**
   * The shape-rendering attribute. The behavior of the different options is described on the
   * [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/shape-rendering).
   * If you are having issues with blurry icons you should investigate this prop.
   */
  shapeRendering: import_prop_types3.default.string,
  /**
   * The system prop that allows defining system overrides as well as additional CSS styles.
   */
  sx: import_prop_types3.default.oneOfType([import_prop_types3.default.arrayOf(import_prop_types3.default.oneOfType([import_prop_types3.default.func, import_prop_types3.default.object, import_prop_types3.default.bool])), import_prop_types3.default.func, import_prop_types3.default.object]),
  /**
   * Provides a human-readable title for the element that contains it.
   * https://www.w3.org/TR/SVG-access/#Equivalent
   */
  titleAccess: import_prop_types3.default.string,
  /**
   * Allows you to redefine what the coordinates without units mean inside an SVG element.
   * For example, if the SVG element is 500 (width) by 200 (height),
   * and you pass viewBox="0 0 50 20",
   * this means that the coordinates inside the SVG will go from the top left corner (0,0)
   * to bottom right (50,20) and each unit will be worth 10px.
   * @default '0 0 24 24'
   */
  viewBox: import_prop_types3.default.string
} : void 0;
SvgIcon.muiName = "SvgIcon";
var SvgIcon_default = SvgIcon;

// node_modules/@mui/material/utils/createSvgIcon.js
var import_jsx_runtime5 = __toESM(require_jsx_runtime());
function createSvgIcon(path, displayName) {
  function Component(props, ref) {
    return (0, import_jsx_runtime5.jsx)(SvgIcon_default, {
      "data-testid": `${displayName}Icon`,
      ref,
      ...props,
      children: path
    });
  }
  if (true) {
    Component.displayName = `${displayName}Icon`;
  }
  Component.muiName = SvgIcon_default.muiName;
  return React5.memo(React5.forwardRef(Component));
}

// node_modules/@mui/material/internal/svg-icons/SuccessOutlined.js
var import_jsx_runtime6 = __toESM(require_jsx_runtime());
var SuccessOutlined_default = createSvgIcon((0, import_jsx_runtime6.jsx)("path", {
  d: "M20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4C12.76,4 13.5,4.11 14.2, 4.31L15.77,2.74C14.61,2.26 13.34,2 12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0, 0 22,12M7.91,10.08L6.5,11.5L11,16L21,6L19.59,4.58L11,13.17L7.91,10.08Z"
}), "SuccessOutlined");

// node_modules/@mui/material/internal/svg-icons/ReportProblemOutlined.js
var React7 = __toESM(require_react());
var import_jsx_runtime7 = __toESM(require_jsx_runtime());
var ReportProblemOutlined_default = createSvgIcon((0, import_jsx_runtime7.jsx)("path", {
  d: "M12 5.99L19.53 19H4.47L12 5.99M12 2L1 21h22L12 2zm1 14h-2v2h2v-2zm0-6h-2v4h2v-4z"
}), "ReportProblemOutlined");

// node_modules/@mui/material/internal/svg-icons/ErrorOutline.js
var React8 = __toESM(require_react());
var import_jsx_runtime8 = __toESM(require_jsx_runtime());
var ErrorOutline_default = createSvgIcon((0, import_jsx_runtime8.jsx)("path", {
  d: "M11 15h2v2h-2zm0-8h2v6h-2zm.99-5C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"
}), "ErrorOutline");

// node_modules/@mui/material/internal/svg-icons/InfoOutlined.js
var React9 = __toESM(require_react());
var import_jsx_runtime9 = __toESM(require_jsx_runtime());
var InfoOutlined_default = createSvgIcon((0, import_jsx_runtime9.jsx)("path", {
  d: "M11,9H13V7H11M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 20,7.59 20, 12C20,16.41 16.41,20 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10, 10 0 0,0 12,2M11,17H13V11H11V17Z"
}), "InfoOutlined");

// node_modules/@mui/material/internal/svg-icons/Close.js
var React10 = __toESM(require_react());
var import_jsx_runtime10 = __toESM(require_jsx_runtime());
var Close_default = createSvgIcon((0, import_jsx_runtime10.jsx)("path", {
  d: "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"
}), "Close");

// node_modules/@mui/material/Alert/Alert.js
var import_jsx_runtime11 = __toESM(require_jsx_runtime());
var import_jsx_runtime12 = __toESM(require_jsx_runtime());
var useUtilityClasses4 = (ownerState) => {
  const {
    variant,
    color,
    severity,
    classes
  } = ownerState;
  const slots = {
    root: ["root", `${variant}${capitalize_default(color || severity)}`, `${variant}`],
    icon: ["icon"],
    message: ["message"],
    action: ["action"]
  };
  return composeClasses(slots, getAlertUtilityClass, classes);
};
var AlertRoot = styled_default(Paper_default, {
  name: "MuiAlert",
  slot: "Root",
  overridesResolver: (props, styles) => {
    const {
      ownerState
    } = props;
    return [styles.root, styles[ownerState.variant], styles[`${ownerState.variant}${capitalize_default(ownerState.color || ownerState.severity)}`]];
  }
})(({
  theme,
  ownerState
}) => {
  const getColor = theme.palette.mode === "light" ? darken : lighten;
  const getBackgroundColor = theme.palette.mode === "light" ? lighten : darken;
  const color = ownerState.color || ownerState.severity;
  return {
    ...theme.typography.body2,
    backgroundColor: "transparent",
    display: "flex",
    padding: "6px 16px",
    ...color && ownerState.variant === "standard" && {
      color: theme.vars ? theme.vars.palette.Alert[`${color}Color`] : getColor(theme.palette[color].light, 0.6),
      backgroundColor: theme.vars ? theme.vars.palette.Alert[`${color}StandardBg`] : getBackgroundColor(theme.palette[color].light, 0.9),
      [`& .${alertClasses_default.icon}`]: theme.vars ? {
        color: theme.vars.palette.Alert[`${color}IconColor`]
      } : {
        color: theme.palette[color].main
      }
    },
    ...color && ownerState.variant === "outlined" && {
      color: theme.vars ? theme.vars.palette.Alert[`${color}Color`] : getColor(theme.palette[color].light, 0.6),
      border: `1px solid ${(theme.vars || theme).palette[color].light}`,
      [`& .${alertClasses_default.icon}`]: theme.vars ? {
        color: theme.vars.palette.Alert[`${color}IconColor`]
      } : {
        color: theme.palette[color].main
      }
    },
    ...color && ownerState.variant === "filled" && {
      fontWeight: theme.typography.fontWeightMedium,
      ...theme.vars ? {
        color: theme.vars.palette.Alert[`${color}FilledColor`],
        backgroundColor: theme.vars.palette.Alert[`${color}FilledBg`]
      } : {
        backgroundColor: theme.palette.mode === "dark" ? theme.palette[color].dark : theme.palette[color].main,
        color: theme.palette.getContrastText(theme.palette[color].main)
      }
    }
  };
});
var AlertIcon = styled_default("div", {
  name: "MuiAlert",
  slot: "Icon",
  overridesResolver: (props, styles) => styles.icon
})({
  marginRight: 12,
  padding: "7px 0",
  display: "flex",
  fontSize: 22,
  opacity: 0.9
});
var AlertMessage = styled_default("div", {
  name: "MuiAlert",
  slot: "Message",
  overridesResolver: (props, styles) => styles.message
})({
  padding: "8px 0",
  minWidth: 0,
  overflow: "auto"
});
var AlertAction = styled_default("div", {
  name: "MuiAlert",
  slot: "Action",
  overridesResolver: (props, styles) => styles.action
})({
  display: "flex",
  alignItems: "flex-start",
  padding: "4px 0 0 16px",
  marginLeft: "auto",
  marginRight: -8
});
var defaultIconMapping = {
  success: (0, import_jsx_runtime11.jsx)(SuccessOutlined_default, {
    fontSize: "inherit"
  }),
  warning: (0, import_jsx_runtime11.jsx)(ReportProblemOutlined_default, {
    fontSize: "inherit"
  }),
  error: (0, import_jsx_runtime11.jsx)(ErrorOutline_default, {
    fontSize: "inherit"
  }),
  info: (0, import_jsx_runtime11.jsx)(InfoOutlined_default, {
    fontSize: "inherit"
  })
};
var Alert = React11.forwardRef(function Alert2(inProps, ref) {
  var _ref, _slots$closeButton, _ref2, _slots$closeIcon, _slotProps$closeButto, _slotProps$closeIcon;
  const props = useThemeProps({
    props: inProps,
    name: "MuiAlert"
  });
  const {
    action,
    children,
    className,
    closeText = "Close",
    color,
    components = {},
    componentsProps = {},
    icon,
    iconMapping = defaultIconMapping,
    onClose,
    role = "alert",
    severity = "success",
    slotProps = {},
    slots = {},
    variant = "standard",
    ...other
  } = props;
  const ownerState = {
    ...props,
    color,
    severity,
    variant
  };
  const classes = useUtilityClasses4(ownerState);
  const AlertCloseButton = (_ref = (_slots$closeButton = slots.closeButton) != null ? _slots$closeButton : components.CloseButton) != null ? _ref : IconButton_default;
  const AlertCloseIcon = (_ref2 = (_slots$closeIcon = slots.closeIcon) != null ? _slots$closeIcon : components.CloseIcon) != null ? _ref2 : Close_default;
  const closeButtonProps = (_slotProps$closeButto = slotProps.closeButton) != null ? _slotProps$closeButto : componentsProps.closeButton;
  const closeIconProps = (_slotProps$closeIcon = slotProps.closeIcon) != null ? _slotProps$closeIcon : componentsProps.closeIcon;
  return (0, import_jsx_runtime12.jsxs)(AlertRoot, {
    role,
    elevation: 0,
    ownerState,
    className: clsx_m_default(classes.root, className),
    ref,
    ...other,
    children: [icon !== false ? (0, import_jsx_runtime11.jsx)(AlertIcon, {
      ownerState,
      className: classes.icon,
      children: icon || iconMapping[severity] || defaultIconMapping[severity]
    }) : null, (0, import_jsx_runtime11.jsx)(AlertMessage, {
      ownerState,
      className: classes.message,
      children
    }), action != null ? (0, import_jsx_runtime11.jsx)(AlertAction, {
      ownerState,
      className: classes.action,
      children: action
    }) : null, action == null && onClose ? (0, import_jsx_runtime11.jsx)(AlertAction, {
      ownerState,
      className: classes.action,
      children: (0, import_jsx_runtime11.jsx)(AlertCloseButton, {
        size: "small",
        "aria-label": closeText,
        title: closeText,
        color: "inherit",
        onClick: onClose,
        ...closeButtonProps,
        children: (0, import_jsx_runtime11.jsx)(AlertCloseIcon, {
          fontSize: "small",
          ...closeIconProps
        })
      })
    }) : null]
  });
});
true ? Alert.propTypes = {
  // ----------------------------- Warning --------------------------------
  // | These PropTypes are generated from the TypeScript type definitions |
  // |     To update them edit the d.ts file and run "yarn proptypes"     |
  // ----------------------------------------------------------------------
  /**
   * The action to display. It renders after the message, at the end of the alert.
   */
  action: import_prop_types4.default.node,
  /**
   * The content of the component.
   */
  children: import_prop_types4.default.node,
  /**
   * Override or extend the styles applied to the component.
   */
  classes: import_prop_types4.default.object,
  /**
   * @ignore
   */
  className: import_prop_types4.default.string,
  /**
   * Override the default label for the *close popup* icon button.
   *
   * For localization purposes, you can use the provided [translations](/material-ui/guides/localization/).
   * @default 'Close'
   */
  closeText: import_prop_types4.default.string,
  /**
   * The color of the component. Unless provided, the value is taken from the `severity` prop.
   * It supports both default and custom theme colors, which can be added as shown in the
   * [palette customization guide](https://mui.com/material-ui/customization/palette/#adding-new-colors).
   */
  color: import_prop_types4.default.oneOfType([import_prop_types4.default.oneOf(["error", "info", "success", "warning"]), import_prop_types4.default.string]),
  /**
   * The components used for each slot inside.
   *
   * This prop is an alias for the `slots` prop.
   * It's recommended to use the `slots` prop instead.
   *
   * @default {}
   */
  components: import_prop_types4.default.shape({
    CloseButton: import_prop_types4.default.elementType,
    CloseIcon: import_prop_types4.default.elementType
  }),
  /**
   * The extra props for the slot components.
   * You can override the existing props or add new ones.
   *
   * This prop is an alias for the `slotProps` prop.
   * It's recommended to use the `slotProps` prop instead, as `componentsProps` will be deprecated in the future.
   *
   * @default {}
   */
  componentsProps: import_prop_types4.default.shape({
    closeButton: import_prop_types4.default.object,
    closeIcon: import_prop_types4.default.object
  }),
  /**
   * Override the icon displayed before the children.
   * Unless provided, the icon is mapped to the value of the `severity` prop.
   * Set to `false` to remove the `icon`.
   */
  icon: import_prop_types4.default.node,
  /**
   * The component maps the `severity` prop to a range of different icons,
   * for instance success to `<SuccessOutlined>`.
   * If you wish to change this mapping, you can provide your own.
   * Alternatively, you can use the `icon` prop to override the icon displayed.
   */
  iconMapping: import_prop_types4.default.shape({
    error: import_prop_types4.default.node,
    info: import_prop_types4.default.node,
    success: import_prop_types4.default.node,
    warning: import_prop_types4.default.node
  }),
  /**
   * Callback fired when the component requests to be closed.
   * When provided and no `action` prop is set, a close icon button is displayed that triggers the callback when clicked.
   * @param {React.SyntheticEvent} event The event source of the callback.
   */
  onClose: import_prop_types4.default.func,
  /**
   * The ARIA role attribute of the element.
   * @default 'alert'
   */
  role: import_prop_types4.default.string,
  /**
   * The severity of the alert. This defines the color and icon used.
   * @default 'success'
   */
  severity: import_prop_types4.default.oneOf(["error", "info", "success", "warning"]),
  /**
   * The extra props for the slot components.
   * You can override the existing props or add new ones.
   *
   * This prop is an alias for the `componentsProps` prop, which will be deprecated in the future.
   *
   * @default {}
   */
  slotProps: import_prop_types4.default.shape({
    closeButton: import_prop_types4.default.object,
    closeIcon: import_prop_types4.default.object
  }),
  /**
   * The components used for each slot inside.
   *
   * This prop is an alias for the `components` prop, which will be deprecated in the future.
   *
   * @default {}
   */
  slots: import_prop_types4.default.shape({
    closeButton: import_prop_types4.default.elementType,
    closeIcon: import_prop_types4.default.elementType
  }),
  /**
   * The system prop that allows defining system overrides as well as additional CSS styles.
   */
  sx: import_prop_types4.default.oneOfType([import_prop_types4.default.arrayOf(import_prop_types4.default.oneOfType([import_prop_types4.default.func, import_prop_types4.default.object, import_prop_types4.default.bool])), import_prop_types4.default.func, import_prop_types4.default.object]),
  /**
   * The variant to use.
   * @default 'standard'
   */
  variant: import_prop_types4.default.oneOfType([import_prop_types4.default.oneOf(["filled", "outlined", "standard"]), import_prop_types4.default.string])
} : void 0;
var Alert_default = Alert;
export {
  alertClasses_default as alertClasses,
  Alert_default as default,
  getAlertUtilityClass
};
//# sourceMappingURL=@mui_material_Alert.js.map
