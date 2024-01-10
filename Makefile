help: ## Display this help screen
	@grep -h \
		-E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## zk stack init
	@zk stack init

init_prover: ## download the keys/srs. Key in:  /mnt/paul/zksync-era/etc/hyperchains/prover-keys/docker
	@zk stack prover-setup

prover_status: ## prover statut
	@zk status prover

start_common: ## start database and
	@echo "start database"
	@sudo docker-compose -f docker-compose-zkstack-common.yml up -d postgres
	@echo "start geth"
	@sudo docker-compose -f docker-compose-zkstack-common.yml up -d geth

start_server: ## start server service
	@nohup zk server --components "http_api,tree,eth,state_keeper,housekeeper" > logs/server_log_a &

login_db: ## pswd: notsecurepassword
	@psql -h localhost -U postgres


login_geth: ## enter geth's docker bash
	@docker container exec -it geth  geth attach http://localhost:8545

.PHONY: clippy fmt test