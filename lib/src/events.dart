enum ReadyState { connecting, open, closing, closed }
Map<int, ReadyState> _readyStateMap = {
  0: ReadyState.connecting,
  1: ReadyState.open,
  2: ReadyState.closing,
  3: ReadyState.closed
};
