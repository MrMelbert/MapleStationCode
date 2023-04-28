/// Avoids division by zero by returning 0 if the divisor is 0 or null.
#define SAFE_DIVIDE(dividend, divisor) (!divisor ? 0 : dividend/divisor)
