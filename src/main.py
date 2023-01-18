# Standard library
import sys

# Third party
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

tracer = trace.get_tracer(__name__)

if __name__ == "__main__":
    with tracer.start_as_current_span("testing_123"):
        print("Testing, testing, 1 2 3")
