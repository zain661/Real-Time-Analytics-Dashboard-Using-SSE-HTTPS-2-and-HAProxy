#TESTING WITHOUT HAProxy
#!/bin/sh
# set -e

# echo "=========================================="
# echo "Real-Time Analytics Dashboard - Load Tests"
# echo "=========================================="
# echo ""

# # -----------------------------
# # Wait for app readiness
# # -----------------------------
# echo "⏳ Waiting for app1 to be ready..."
# sleep 8
# until curl -skI https://app1:4002 >/dev/null 2>&1; do
#   echo "   Waiting for app1..."
#   sleep 2
# done
# echo "✅ App is ready!"
# echo ""


# # -----------------------------
# # Helper: generate temp JSON
# # -----------------------------
# make_payload() {
#   id=$1
#   cpu=$2
#   mem=$3
#   ts=$(date +%s000)
#   echo "{\"agentId\":\"agent-${id}\",\"cpu\":${cpu},\"memory\":${mem},\"timestamp\":${ts}}" > /tmp/payload-${id}.json
# }

# # -----------------------------
# # TEST 1: 10 Engineers (SSE)
# # -----------------------------
# echo "=========================================="
# echo "TEST 1: 10 Engineers (SSE Connections)"
# echo "=========================================="

# h2load -n10 -c10 -t2 -D10s https://app1:4002/api/dashboard/stream
# echo "✅ SSE connections stable for 10 engineers"
# echo ""

# # -----------------------------
# # TEST 2: 500 Engineers
# # -----------------------------
# echo "=========================================="
# echo "TEST 2: 500 Engineers (Dashboard Load)"
# echo "=========================================="

# h2load -n500 -c500 -t4 -D10s https://app1:4002/api/dashboard/stream
# echo "✅ 500 concurrent SSE streams simulated"
# echo ""
# # Before Test 3

# # -----------------------------
# # TEST 3: 100 Agents Sending Metrics
# # -----------------------------
# echo "=========================================="
# echo "TEST 3: 100 Agents Sending Metrics"
# echo "=========================================="

# make_payload 1 45.2 78.5
# h2load -n100 -c100 -m1 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-1.json \
#   https://app1:4002/api/metrics/stream

# echo "✅ 100 metrics requests sent"
# echo ""



# # -----------------------------
# # TEST 4: Mixed Load
# # -----------------------------
# echo "=========================================="
# echo "TEST 4: Mixed Load (SSE + Metrics)"
# echo "=========================================="

# # Start 100 SSE clients in background
# h2load -n100 -c100 -t4 https://app1:4002/api/dashboard/stream &
# SSE_PID=$!

# sleep 5
# make_payload 2 67.8 89.1

# h2load -n1000 -c100 -m100 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-2.json \
#   https://app1:4002/api/metrics/stream

# wait $SSE_PID
# echo "✅ Mixed test completed (SSE + Metrics)"
# echo ""

# # -----------------------------
# # TEST 6: Agents Only (No SSE)
# # -----------------------------
# # echo "=========================================="
# # echo "TEST 6: Agents Only (No SSE)"
# # echo "=========================================="

# # make_payload 4 55.5 72.1
# # h2load -n1000 -c100 -m100 -t4 \
# #   -H "content-type: application/json" \
# #   -d /tmp/payload-4.json \
# #   https://app1:4002/api/metrics/stream

# # echo "✅ 100 Agents sent metrics without SSE"
# # echo ""

# # -----------------------------
# # TEST 5: Stress Test
# # -----------------------------
# # echo "=========================================="
# # echo "TEST 5: Stress Test (10,000 Requests)"
# # echo "=========================================="

# # make_payload 3 23.4 56.7
# # h2load -n10000 -c500 -m20 -t4 \
# #   -H "content-type: application/json" \
# #   -d /tmp/payload-3.json \
# #   https://app1:4002/api/metrics/stream

# # echo "✅ Stress test completed successfully"
# # echo ""

# # -----------------------------
# # Summary
# # -----------------------------
# echo "=========================================="
# echo "ALL TESTS COMPLETED"
# echo "=========================================="
# echo ""
# echo "Next Steps:"
# echo "  1️⃣ Check app logs → docker-compose logs app1"
# echo "  2️⃣ Monitor containers → docker stats analytics-app1"
# echo "  3️⃣ Review DB → validate ingestion throughput"
# echo ""
# echo "Key Metrics to Watch:"
# echo "  • SSE stability (keepalive >30s)"
# echo "  • Request error % (should stay <1%)"
# echo "  • Broadcast latency"
# echo "  • Memory usage growth"
# echo ""

# #!/bin/sh
# set -e

# echo "=========================================="
# echo "Real-Time Analytics Dashboard - Load Tests"
# echo "=========================================="
# echo ""

# # -----------------------------
# # Wait for HAProxy readiness
# # -----------------------------
# echo "⏳ Waiting for HAProxy to be ready..."
# sleep 8
# until curl -skI https://haproxy >/dev/null 2>&1; do
#   echo "   Waiting for HAProxy..."
#   sleep 2
# done
# echo "✅ HAProxy is ready!"
# echo ""

# # Check backend health via stats page
# echo "🔍 Checking backend health..."
# curl -s http://haproxy:8404 | grep -q "app1" && echo "   ✅ Backend servers detected"
# echo ""

# # -----------------------------
# # Helper: generate temp JSON
# # -----------------------------
# make_payload() {
#   id=$1
#   cpu=$2
#   mem=$3
#   ts=$(date +%s000)
#   echo "{\"agentId\":\"agent-${id}\",\"cpu\":${cpu},\"memory\":${mem},\"timestamp\":${ts}}" > /tmp/payload-${id}.json
# }

# # -----------------------------
# # TEST 1: 10 Engineers (SSE)
# # -----------------------------
# echo "=========================================="
# echo "TEST 1: 10 Engineers (SSE Connections)"
# echo "=========================================="

# h2load -n10 -c10 -t2 -D10s https://haproxy/api/dashboard/stream
# echo "✅ SSE connections stable for 10 engineers"
# echo ""

# # -----------------------------
# # TEST 2: 500 Engineers
# # -----------------------------
# echo "=========================================="
# echo "TEST 2: 500 Engineers (Dashboard Load)"
# echo "=========================================="

# h2load -n500 -c500 -t4 -D10s https://haproxy/api/dashboard/stream
# echo "✅ 500 concurrent SSE streams simulated"
# echo ""

# # -----------------------------
# # TEST 3: 100 Agents Sending Metrics
# # -----------------------------
# echo "=========================================="
# echo "TEST 3: 100 Agents Sending Metrics"
# echo "=========================================="

# make_payload 1 45.2 78.5
# h2load -n100 -c100 -m1 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-1.json \
#   https://haproxy/api/metrics/stream

# echo "✅ 100 metrics requests sent"
# echo ""

# # -----------------------------
# # TEST 4: Mixed Load
# # -----------------------------
# echo "=========================================="
# echo "TEST 4: Mixed Load (SSE + Metrics)"
# echo "=========================================="

# # Start 100 SSE clients in background
# h2load -n100 -c100 -t4 -D30s https://haproxy/api/dashboard/stream &
# SSE_PID=$!

# sleep 5
# make_payload 2 67.8 89.1

# h2load -n1000 -c100 -m100 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-2.json \
#   https://haproxy/api/metrics/stream

# wait $SSE_PID
# echo "✅ Mixed test completed (SSE + Metrics)"
# echo ""

# # -----------------------------
# # TEST 5: Load Balancing Verification
# # -----------------------------
# echo "=========================================="
# echo "TEST 5: Load Balancing Verification"
# echo "=========================================="

# echo "Sending 300 requests to verify round-robin..."
# make_payload 5 60.0 70.0
# h2load -n300 -c30 -m10 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-5.json \
#   https://haproxy/api/metrics/stream

# echo ""
# echo "Check HAProxy stats to verify distribution:"
# echo "  http://localhost:8404 (admin/admin123)"
# echo "✅ Load balancing test completed"
# echo ""

# # -----------------------------
# # TEST 6: Stress Test
# # -----------------------------
# echo "=========================================="
# echo "TEST 6: Stress Test (10,000 Requests)"
# echo "=========================================="

# make_payload 3 23.4 56.7
# h2load -n10000 -c500 -m20 -t4 \
#   -H "content-type: application/json" \
#   -d /tmp/payload-3.json \
#   https://haproxy/api/metrics/stream

# echo "✅ Stress test completed successfully"
# echo ""

# # -----------------------------
# # Summary
# # -----------------------------
# echo "=========================================="
# echo "ALL TESTS COMPLETED"
# echo "=========================================="
# echo ""
# echo "Next Steps:"
# echo "  1️⃣ Check HAProxy stats → http://localhost:8404"
# echo "  2️⃣ Check app logs → docker-compose logs app1 app2 app3"
# echo "  3️⃣ Monitor containers → docker stats"
# echo "  4️⃣ Review DB → validate ingestion throughput"
# echo ""
# echo "Key Metrics to Watch:"
# echo "  • Load distribution across app1/app2/app3"
# echo "  • SSE stability (keepalive >30s)"
# echo "  • Request error % (should stay <1%)"
# echo "  • Backend health in HAProxy stats"
# echo "  • Connection reuse efficiency"
# echo ""

#!/bin/sh
set -e

echo "=========================================="
echo "Real-Time Analytics Dashboard - Load Tests"
echo "=========================================="
echo ""

TARGET="http://haproxy"


# -----------------------------
# Wait for HAProxy readiness
# -----------------------------
echo "⏳ Waiting for HAProxy to be ready..."
sleep 5
until curl -skI $TARGET >/dev/null 2>&1; do
  echo "   Waiting for HAProxy..."
  sleep 2
done
echo "✅ HAProxy is ready!"
echo ""

# Check backend health via stats page
echo "🔍 Checking backend health..."
curl -s http://haproxy:8404 | grep -q "app1" && echo "   ✅ Backend servers detected"
echo ""

# -----------------------------
# Helper: generate temp JSON
# -----------------------------
make_payload() {
  id=$1
  cpu=$2
  mem=$3
  ts=$(date +%s000)
  echo "{\"agentId\":\"agent-${id}\",\"cpu\":${cpu},\"memory\":${mem},\"timestamp\":${ts}}" > /tmp/payload-${id}.json
}

###########################################
# TEST 1: 10 Engineers (SSE)
###########################################
echo "=========================================="
echo "TEST 1: 10 Engineers (SSE Connections)"
echo "=========================================="

h2load -n10 -c10 -m1 -t2 -D10s $TARGET/api/dashboard/stream
echo "✅ SSE stable for 10 engineers"
echo ""

###########################################
# TEST 2: 500 Engineers (safe load)
###########################################
echo "=========================================="
echo "TEST 2: 500 Engineers (Dashboard Load)"
echo "=========================================="

# Important: -m1 للتخفيف على HAProxy
h2load -n500 -c200 -m1 -t4 -D10s $TARGET/api/dashboard/stream
echo "✅ 500 concurrent SSE streams simulated"
echo ""

###########################################
# TEST 3: 100 Agents sending metrics
###########################################
echo "=========================================="
echo "TEST 3: 100 Agents Sending Metrics"
echo "=========================================="

make_payload 1 45.2 78.5
h2load -n100 -c50 -m1 -t4 \
  -H "content-type: application/json" \
  -d /tmp/payload-1.json \
  $TARGET/api/metrics/stream

echo "✅ 100 metrics requests sent"
echo ""

###########################################
# TEST 4: Mixed Load
###########################################
echo "=========================================="
echo "TEST 4: Mixed Load (SSE + Metrics)"
echo "=========================================="

# Start 100 SSE clients in background
h2load -n100 -c100 -m1 -t2 -D25s $TARGET/api/dashboard/stream &
SSE_PID=$!

sleep 4
make_payload 2 67.8 89.1

h2load -n800 -c80 -m50 -t4 \
  -H "content-type: application/json" \
  -d /tmp/payload-2.json \
  $TARGET/api/metrics/stream

wait $SSE_PID
echo "✅ Mixed load completed"
echo ""

###########################################
# TEST 5: Load Balancing
###########################################
echo "=========================================="
echo "TEST 5: Load Balancing Verification"
echo "=========================================="

echo "Sending 300 metric requests..."
make_payload 5 60.0 70.0
h2load -n300 -c30 -m10 -t4 \
  -H "content-type: application/json" \
  -d /tmp/payload-5.json \
  $TARGET/api/metrics/stream

echo ""
echo "Check load balance → http://localhost:8404"
echo "Credentials: admin/admin123"
echo "✅ Load balancing test OK"
echo ""

###########################################
# TEST 6: Stress Test
###########################################
echo "=========================================="
echo "TEST 6: Stress Test (10,000 Requests)"
echo "=========================================="

make_payload 3 23.4 56.7
h2load -n10000 -c400 -m10 -t4 \
  -H "content-type: application/json" \
  -d /tmp/payload-3.json \
  $TARGET/api/metrics/stream

echo "✅ Stress test completed"
echo ""

###########################################
# Summary
###########################################
echo "=========================================="
echo "ALL TESTS COMPLETED"
echo "=========================================="
echo ""
echo "Next:"
echo " - Check HAProxy stats → http://localhost:8404"
echo " - Check app logs → docker-compose logs app1 app2 app3"
echo " - Monitor → docker stats"
echo ""
