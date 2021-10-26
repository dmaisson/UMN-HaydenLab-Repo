function [Results] = Latency_Murray_wrapper(Raw)
Results.data13.latency.Murray = Latency_Murray_SmDelta(Raw.data13);
Results.data11.latency.Murray = Latency_Murray_SmDelta(Raw.data11);
Results.data14.latency.Murray = Latency_Murray_SmDelta(Raw.data14);
Results.data25.latency.Murray = Latency_Murray_SmDelta(Raw.data25);
Results.data32.latency.Murray = Latency_Murray_SmDelta(Raw.data32);
Results.dataPCC.latency.Murray = Latency_Murray_SmDelta(Raw.dataPCC);
Results.dataVS.latency.Murray = Latency_Murray_SmDelta(Raw.dataVS);
Results.data24.latency.Murray = Latency_Murray_SmDelta(Raw.data24);

Results.Murray(1,1) = Results.data13.latency.Murray.tau;
Results.Murray(2,1) = Results.data11.latency.Murray.tau;
Results.Murray(3,1) = Results.data14.latency.Murray.tau;
Results.Murray(4,1) = Results.data25.latency.Murray.tau;
Results.Murray(5,1) = Results.data32.latency.Murray.tau;
Results.Murray(6,1) = Results.dataPCC.latency.Murray.tau;
Results.Murray(7,1) = Results.dataVS.latency.Murray.tau;
Results.Murray(8,1) = Results.data24.latency.Murray.tau;
clear Raw;
end