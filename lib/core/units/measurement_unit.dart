/// Units of mass the app accepts for input and display.
///
/// The store always persists grams (see AGENTS.md "store canonical metric");
/// the imperial members exist only to convert at the edges.
enum MassUnit { gram, ounce, pound }

/// Units of volume the app accepts for input and display.
///
/// The store always persists milliliters; [fluidOunce] is the US fluid ounce.
enum VolumeUnit { milliliter, fluidOunce }

/// The unit a food's serving size is expressed in.
///
/// [piece] is a discrete count (e.g. "2 cookies") with no metric conversion.
enum ServingUnit { gram, milliliter, piece }
