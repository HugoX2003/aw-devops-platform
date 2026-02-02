moved {
  from = module.vpc
  to   = module.network.module.vpc
}